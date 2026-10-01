"""SEO no servidor: injeta meta tags e dados estruturados no <head> das páginas.

O conteúdo do site é renderizado via JavaScript, mas buscadores e redes sociais
(WhatsApp, LinkedIn, Facebook) leem o <head> do HTML inicial. Por isso as tags
marcadas com data-seo="..." são preenchidas aqui com dados do banco.
"""
import html
import json
import re
from datetime import datetime
from xml.sax.saxutils import escape as xml_escape

from flask import current_app, request

from db import query_all, query_one
from resources import PROFILE, RESOURCES, excerpt

DEFAULT_IMAGE = "assets/img/og-image.jpg"


def site_url():
    configured = current_app.config.get("SITE_URL")
    return (configured or request.url_root).rstrip("/")


def absolute(url):
    url = (url or "").strip()
    if not url:
        return ""
    if re.match(r"^https?://", url, re.I):
        return url
    if url.startswith("//"):
        return "https:" + url
    return f"{site_url()}/{url.lstrip('/')}"


def _clip(text, size=160):
    text = re.sub(r"\s+", " ", text or "").strip()
    return text if len(text) <= size else text[: size - 1].rstrip(" ,.;:") + "…"


def _json_ld(data):
    # "</" dentro do JSON fecharia a tag <script>
    return json.dumps(data, ensure_ascii=False, indent=2).replace("</", "<\\/")


def _replace_attr(page, key, value):
    """Troca o content/href de todas as tags com data-seo="key"."""
    pattern = re.compile(r'(<(?:meta|link)\b[^>]*\bdata-seo="%s"[^>]*?\b(?:content|href)=")[^"]*(")' % re.escape(key))
    return pattern.sub(lambda m: m.group(1) + html.escape(value, quote=True) + m.group(2), page)


def apply(page, meta):
    if meta.get("title"):
        page = re.sub(
            r'(<title\b[^>]*data-seo="title"[^>]*>)[\s\S]*?(</title>)',
            lambda m: m.group(1) + html.escape(meta["title"]) + m.group(2),
            page,
        )
    for key in ("title", "description", "url", "image", "image_alt", "type", "keywords", "preload_image"):
        if meta.get(key):
            page = _replace_attr(page, key, meta[key])
    if meta.get("json_ld"):
        page = re.sub(
            r'(<script\b[^>]*data-seo="jsonld"[^>]*>)[\s\S]*?(</script>)',
            lambda m: m.group(1) + "\n" + _json_ld(meta["json_ld"]) + "\n  " + m.group(2),
            page,
        )
    return page


def _profile():
    return PROFILE.serialize(query_one("SELECT * FROM profile WHERE id = 1")) or {}


def _social_urls():
    rows = query_all("SELECT url FROM contacts WHERE show_in_social = 1 ORDER BY sort_order, id")
    return [r["url"] for r in rows if r["url"] and r["url"].startswith("http")]


def _address(location):
    parts = [p.strip() for p in re.split(r"\s*[-,/]\s*", location or "") if p.strip()]
    if not parts:
        return None
    address = {"@type": "PostalAddress", "addressLocality": parts[0], "addressCountry": "BR"}
    if len(parts) > 1:
        address["addressRegion"] = parts[1]
    return address


def _person(profile, base):
    person = {
        "@type": "Person",
        "@id": f"{base}/#person",
        "name": profile.get("full_name"),
        "jobTitle": profile.get("role_title"),
        "url": f"{base}/",
        "image": absolute(profile.get("hero_image")) or absolute(DEFAULT_IMAGE),
        "description": _clip(profile.get("about_text"), 300),
        "sameAs": _social_urls(),
    }
    address = _address(profile.get("location"))
    if address:
        person["address"] = address

    skills = query_all("SELECT name FROM skills ORDER BY sort_order, id")
    if skills:
        person["knowsAbout"] = [s["name"] for s in skills]

    schools = query_all("SELECT DISTINCT institution FROM education")
    if schools:
        person["alumniOf"] = [{"@type": "EducationalOrganization", "name": s["institution"]} for s in schools]

    current = query_one(
        "SELECT company FROM experiences WHERE period LIKE %s ORDER BY sort_order, id LIMIT 1", ("%tual%",)
    )
    if current:
        person["worksFor"] = {"@type": "Organization", "name": current["company"]}

    return {k: v for k, v in person.items() if v}


def home_meta():
    profile = _profile()
    base = site_url()
    name = profile.get("full_name") or "Portfólio"
    role = profile.get("role_title")
    title = f"{name} | {role} — Integrações, APIs e Agricultura de Precisão" if role else name
    description = _clip(profile.get("about_text") or profile.get("hero_lead"))
    image = absolute(DEFAULT_IMAGE)

    keywords = [name, role, "desenvolvedor", "integrações", "APIs", "Operations Center", "John Deere",
                "agricultura de precisão", "setor sucroalcooleiro", profile.get("location")]

    return {
        "title": title,
        "description": description,
        "url": f"{base}/",
        "image": image,
        "image_alt": f"{name} — {role}" if role else name,
        "type": "profile",
        "keywords": ", ".join(k for k in keywords if k),
        "preload_image": absolute(profile.get("hero_image")),
        "json_ld": {
            "@context": "https://schema.org",
            "@graph": [
                {
                    "@type": "WebSite",
                    "@id": f"{base}/#website",
                    "url": f"{base}/",
                    "name": name,
                    "inLanguage": "pt-BR",
                    "publisher": {"@id": f"{base}/#person"},
                },
                {
                    "@type": "ProfilePage",
                    "@id": f"{base}/#profilepage",
                    "url": f"{base}/",
                    "name": title,
                    "inLanguage": "pt-BR",
                    "mainEntity": {"@id": f"{base}/#person"},
                },
                _person(profile, base),
            ],
        },
    }


def post_meta(post_id):
    profile = _profile()
    base = site_url()
    name = profile.get("full_name") or "Portfólio"

    post = None
    if post_id and str(post_id).isdigit():
        post = query_one("SELECT * FROM posts WHERE id = %s AND published = 1", (int(post_id),))
    if not post:
        post = query_one("SELECT * FROM posts WHERE published = 1 ORDER BY " + RESOURCES["posts"].order_by + " LIMIT 1")
    if not post:
        return {"title": f"Blog | {name}", "url": f"{base}/service-details.html"}

    post = RESOURCES["posts"].serialize(post)
    url = f"{base}/service-details.html?post={post['id']}"
    description = _clip(excerpt(post.get("content"), 400))
    image = absolute(post.get("img_header")) or absolute(DEFAULT_IMAGE)

    return {
        "title": f"{post['title']} | Blog {name}",
        "description": description,
        "url": url,
        "image": image,
        "image_alt": post["title"],
        "type": "article",
        "keywords": post.get("tag") or "",
        "json_ld": {
            "@context": "https://schema.org",
            "@type": "BlogPosting",
            "mainEntityOfPage": {"@type": "WebPage", "@id": url},
            "headline": _clip(post["title"], 110),
            "description": description,
            "image": [image],
            "datePublished": post.get("created_at"),
            "dateModified": post.get("updated_at") or post.get("created_at"),
            "inLanguage": "pt-BR",
            "keywords": post.get("tag") or None,
            "author": {"@type": "Person", "name": name, "url": f"{base}/"},
            "publisher": {"@type": "Person", "name": name, "url": f"{base}/"},
        },
    }


def render_page(path, raw):
    """Aplica as meta tags do servidor; em caso de erro mantém o HTML original."""
    try:
        if path == "index.html":
            return apply(raw, home_meta())
        if path == "service-details.html":
            return apply(raw, post_meta(request.args.get("post")))
    except Exception:  # noqa: BLE001 - SEO nunca pode derrubar a página
        current_app.logger.exception("Falha ao gerar meta tags de %s", path)
    return raw


def robots_txt():
    return "\n".join([
        "User-agent: *",
        "Allow: /",
        "Disallow: /admin.html",
        "Disallow: /api/",
        "Disallow: /portfolio-details.html",
        "Disallow: /starter-page.html",
        "",
        f"Sitemap: {site_url()}/sitemap.xml",
        "",
    ])


def sitemap_xml():
    base = site_url()
    profile = query_one("SELECT updated_at FROM profile WHERE id = 1")
    posts = query_all("SELECT id, updated_at, created_at FROM posts WHERE published = 1 ORDER BY created_at DESC, id DESC")

    def lastmod(value):
        return value.strftime("%Y-%m-%d") if isinstance(value, datetime) else datetime.now().strftime("%Y-%m-%d")

    urls = [(f"{base}/", lastmod(profile and profile["updated_at"]), "weekly", "1.0")]
    if posts:
        urls.append((f"{base}/service-details.html", lastmod(posts[0]["updated_at"]), "weekly", "0.7"))
    for p in posts:
        urls.append((f"{base}/service-details.html?post={p['id']}", lastmod(p["updated_at"] or p["created_at"]), "monthly", "0.8"))

    body = "\n".join(
        f"  <url>\n    <loc>{xml_escape(loc)}</loc>\n    <lastmod>{mod}</lastmod>\n"
        f"    <changefreq>{freq}</changefreq>\n    <priority>{prio}</priority>\n  </url>"
        for loc, mod, freq, prio in urls
    )
    return f'<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n{body}\n</urlset>\n'
