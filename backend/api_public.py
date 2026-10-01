"""Endpoints públicos consumidos pelo site."""
from flask import Blueprint, abort, jsonify

from db import query_all, query_one
from resources import PROFILE, RESOURCES, excerpt

bp = Blueprint("public", __name__, url_prefix="/api")


def _list(name, where=""):
    res = RESOURCES[name]
    rows = query_all(f"SELECT * FROM {res.table} {where} ORDER BY {res.order_by}")
    return [res.serialize(r) for r in rows]


def _post_summary(row):
    post = RESOURCES["posts"].serialize(row)
    post["excerpt"] = excerpt(post.pop("content", ""))
    post.pop("images", None)
    return post


def _published_posts():
    rows = query_all(
        "SELECT * FROM posts WHERE published = 1 ORDER BY " + RESOURCES["posts"].order_by
    )
    return [_post_summary(r) for r in rows]


def _lines(text):
    return [line.strip() for line in (text or "").splitlines() if line.strip()]


@bp.get("/health")
def health():
    try:
        query_one("SELECT 1 AS ok")
        return jsonify(status="ok", database="ok")
    except Exception as exc:  # noqa: BLE001 - só reporta o estado
        return jsonify(status="error", database=str(exc)), 503


@bp.get("/site")
def site():
    """Tudo que a página inicial precisa, em uma única requisição."""
    profile = PROFILE.serialize(query_one("SELECT * FROM profile WHERE id = 1")) or {}

    categories = _list("skill_categories")
    skills = _list("skills")
    for cat in categories:
        cat["skills"] = [s for s in skills if s["category_id"] == cat["id"]]

    experiences = _list("experiences")
    for exp in experiences:
        exp["achievements"] = _lines(exp.get("achievements"))

    return jsonify(
        profile=profile,
        contacts=_list("contacts"),
        highlights=_list("highlights"),
        timeline=_list("timeline"),
        skill_categories=categories,
        awards=_list("awards"),
        certificates=_list("certificates"),
        experiences=experiences,
        education=_list("education"),
        courses=_list("courses"),
        projects=_list("projects"),
        posts=_published_posts(),
    )


@bp.get("/posts")
def posts():
    return jsonify(_published_posts())


@bp.get("/posts/<int:post_id>")
def post_detail(post_id):
    row = query_one("SELECT * FROM posts WHERE id = %s AND published = 1", (post_id,))
    if not row:
        abort(404, description="Publicação não encontrada.")
    return jsonify(RESOURCES["posts"].serialize(row))


@bp.get("/projects")
def projects():
    return jsonify(_list("projects"))
