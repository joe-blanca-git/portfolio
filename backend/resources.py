"""Definição das tabelas editáveis pelo painel e validação dos dados recebidos.

Cada recurso declara apenas os campos que podem ser gravados. Os endpoints
genéricos de CRUD usam essa lista como whitelist de colunas.
"""
import json
import re
from datetime import date, datetime
from html.parser import HTMLParser

UNSAFE_URL = re.compile(r"^\s*(javascript|data|vbscript):", re.I)
ICON_RE = re.compile(r"^[\w -]{0,60}$")
COLOR_RE = re.compile(r"^#[0-9a-fA-F]{3,8}$")


class ValidationError(Exception):
    def __init__(self, errors):
        super().__init__("Dados inválidos")
        self.errors = errors


class Field:
    def __init__(self, kind="str", required=False, max_length=255, choices=None,
                 min_value=None, max_value=None, default=None):
        self.kind = kind
        self.required = required
        self.max_length = max_length
        self.choices = choices
        self.min_value = min_value
        self.max_value = max_value
        self.default = default

    def clean(self, value):
        if self.kind == "bool":
            if value is None:
                return 1 if self.default else 0
            return 1 if value in (True, 1, "1", "true", "on") else 0

        if self.kind == "url_list":
            return self._clean_url_list(value)

        if value is None or (isinstance(value, str) and value.strip() == ""):
            if self.required:
                raise ValueError("Campo obrigatório.")
            return self.default

        if self.kind == "int":
            try:
                number = int(value)
            except (TypeError, ValueError):
                raise ValueError("Informe um número inteiro.")
            if self.min_value is not None and number < self.min_value:
                raise ValueError(f"Valor mínimo: {self.min_value}.")
            if self.max_value is not None and number > self.max_value:
                raise ValueError(f"Valor máximo: {self.max_value}.")
            return number

        if not isinstance(value, (str, int, float)):
            raise ValueError("Texto inválido.")
        text = str(value).strip()

        if self.max_length and len(text) > self.max_length:
            raise ValueError(f"Máximo de {self.max_length} caracteres.")
        if self.choices and text not in self.choices:
            raise ValueError("Opção inválida.")
        if self.kind == "url" and UNSAFE_URL.match(text):
            raise ValueError("URL não permitida.")
        if self.kind == "icon" and not ICON_RE.match(text):
            raise ValueError("Use o nome da classe do ícone, ex.: bi-code-slash.")
        if self.kind == "color" and not COLOR_RE.match(text):
            raise ValueError("Use uma cor hexadecimal, ex.: #065cc2.")
        return text

    def _clean_url_list(self, value):
        if value in (None, ""):
            items = []
        elif isinstance(value, str):
            items = [line for line in value.splitlines()]
        elif isinstance(value, list):
            items = value
        else:
            raise ValueError("Lista inválida.")

        urls = []
        for item in items:
            url = str(item.get("url") if isinstance(item, dict) else item or "").strip()
            if not url:
                continue
            if UNSAFE_URL.match(url) or len(url) > 1000:
                raise ValueError(f"URL inválida: {url[:60]}")
            urls.append(url)
        return json.dumps(urls)


def Str(max_length=255, required=False, **kw):
    return Field("str", required=required, max_length=max_length, **kw)


def Text(required=False, max_length=65535):
    return Field("text", required=required, max_length=max_length)


def Url(required=False, max_length=1000):
    return Field("url", required=required, max_length=max_length)


def Int(required=False, default=None, **kw):
    return Field("int", required=required, default=default, **kw)


def Order():
    return Field("int", default=0, min_value=0, max_value=9999)


def Icon(required=False):
    return Field("icon", required=required, max_length=60)


def Color():
    return Field("color", max_length=9)


def Bool(default=False):
    return Field("bool", default=default)


class Resource:
    def __init__(self, table, fields, order_by="sort_order ASC, id ASC", label=None):
        self.table = table
        self.fields = fields
        self.order_by = order_by
        self.label = label or table

    def validate(self, payload):
        if not isinstance(payload, dict):
            raise ValidationError({"_": "Envie um objeto JSON."})
        cleaned, errors = {}, {}
        for name, field in self.fields.items():
            try:
                cleaned[name] = field.clean(payload.get(name))
            except ValueError as exc:
                errors[name] = str(exc)
        if errors:
            raise ValidationError(errors)
        return cleaned

    def serialize(self, row):
        if row is None:
            return None
        data = {}
        for key, value in row.items():
            field = self.fields.get(key)
            if isinstance(value, (datetime, date)):
                value = value.isoformat()
            elif field and field.kind == "bool":
                value = bool(value)
            elif field and field.kind == "url_list":
                value = _load_json_list(value)
            data[key] = value
        return data


def _load_json_list(value):
    if isinstance(value, list):
        return value
    try:
        parsed = json.loads(value or "[]")
    except (TypeError, ValueError):
        return []
    return parsed if isinstance(parsed, list) else []


PROJECT_CATEGORIES = ["filter-api", "filter-plataform", "filter-site"]

PROFILE = Resource("profile", {
    "full_name": Str(120, required=True),
    "role_title": Str(160),
    "hero_greeting": Str(160),
    "hero_title": Str(80),
    "hero_typed_items": Str(255),
    "hero_lead": Text(),
    "hero_image": Url(),
    "hero_badges": Str(255),
    "years_experience": Int(min_value=0, max_value=99),
    "about_subtitle": Str(255),
    "about_title": Str(255),
    "about_text": Text(),
    "about_image": Url(),
    "signature_image": Url(),
    "about_quote": Str(255),
    "skills_summary_title": Str(120),
    "skills_summary_text": Text(),
    "experience_quote": Str(255),
    "experience_quote_author": Str(120),
    "education_quote": Str(255),
    "education_quote_author": Str(120),
    "contact_title": Str(160),
    "contact_text": Text(),
    "contact_image": Url(),
    "location": Str(160),
    "footer_tagline": Str(255),
}, label="Perfil")

RESOURCES = {
    "contacts": Resource("contacts", {
        "type": Str(30, required=True, choices=[
            "phone", "whatsapp", "email", "linkedin", "instagram", "github",
            "teams", "facebook", "youtube", "website", "other",
        ]),
        "label": Str(80, required=True),
        "value": Str(255, required=True),
        "url": Url(max_length=500),
        "icon": Icon(),
        "show_in_contact": Bool(True),
        "show_in_social": Bool(False),
        "sort_order": Order(),
    }, label="Contatos"),
    "highlights": Resource("about_highlights", {
        "title": Str(80, required=True),
        "description": Str(255),
        "icon": Icon(),
        "color": Color(),
        "sort_order": Order(),
    }, label="Destaques do Sobre mim"),
    "timeline": Resource("timeline", {
        "year": Str(20, required=True),
        "description": Str(255, required=True),
        "sort_order": Order(),
    }, label="Linha do tempo"),
    "skill_categories": Resource("skill_categories", {
        "title": Str(80, required=True),
        "icon": Icon(),
        "sort_order": Order(),
    }, label="Categorias de habilidades"),
    "skills": Resource("skills", {
        "category_id": Int(required=True, min_value=1),
        "name": Str(120, required=True),
        "level": Int(required=True, min_value=0, max_value=100),
        "sort_order": Order(),
    }, order_by="category_id ASC, sort_order ASC, id ASC", label="Habilidades"),
    "awards": Resource("awards", {
        "value": Str(20),
        "title": Str(120, required=True),
        "subtitle": Str(160),
        "icon": Icon(),
        "sort_order": Order(),
    }, label="Conquistas"),
    "certificates": Resource("certificates", {
        "name": Str(200, required=True),
        "sort_order": Order(),
    }, label="Certificados"),
    "experiences": Resource("experiences", {
        "role": Str(160, required=True),
        "company": Str(160, required=True),
        "period": Str(60, required=True),
        "description": Text(),
        "achievements": Text(),
        "sort_order": Order(),
    }, label="Experiências"),
    "education": Resource("education", {
        "degree": Str(200, required=True),
        "institution": Str(160, required=True),
        "period": Str(60, required=True),
        "description": Text(),
        "sort_order": Order(),
    }, label="Formação acadêmica"),
    "courses": Resource("courses", {
        "title": Str(160, required=True),
        "institution": Str(120, required=True),
        "year": Str(40),
        "icon": Icon(),
        "sort_order": Order(),
    }, label="Cursos"),
    "posts": Resource("posts", {
        "title": Str(255, required=True),
        "tag": Str(255),
        "img_header": Url(),
        "content": Text(max_length=5_000_000),
        "images": Field("url_list"),
        "published": Bool(True),
    }, order_by="created_at DESC, id DESC", label="Blog"),
    "projects": Resource("projects", {
        "title": Str(160, required=True),
        "category": Str(40, required=True, choices=PROJECT_CATEGORIES),
        "image_url": Url(),
        "project_link": Url(),
        "description": Text(),
        "sort_order": Order(),
    }, order_by="sort_order ASC, id DESC", label="Projetos"),
}


class _TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []

    def handle_data(self, data):
        self.parts.append(data)

    def handle_starttag(self, tag, attrs):
        if tag in ("p", "br", "li", "h1", "h2", "h3", "div"):
            self.parts.append(" ")


def html_to_text(html):
    parser = _TextExtractor()
    parser.feed(html or "")
    return re.sub(r"\s+", " ", "".join(parser.parts)).strip()


def excerpt(html, size=260):
    text = html_to_text(html)
    return text if len(text) <= size else text[:size].rstrip() + "…"
