"""Endpoints do painel admin. Todos exigem token (Authorization: Bearer ...)."""
import uuid

import pymysql
from flask import Blueprint, abort, current_app, g, jsonify, request
from werkzeug.security import check_password_hash, generate_password_hash

from auth import login_required
from db import execute, query_all, query_one
from resources import PROFILE, RESOURCES, ValidationError

bp = Blueprint("admin", __name__, url_prefix="/api/admin")

IMAGE_SIGNATURES = {
    "png": [b"\x89PNG\r\n\x1a\n"],
    "jpg": [b"\xff\xd8\xff"],
    "jpeg": [b"\xff\xd8\xff"],
    "gif": [b"GIF87a", b"GIF89a"],
    "webp": [b"RIFF"],
}


@bp.before_request
def _require_login():
    if request.method == "OPTIONS":  # preflight do CORS não carrega o token
        return None
    return login_required(lambda: None)()


@bp.errorhandler(ValidationError)
def _validation_error(exc):
    return jsonify(error="Verifique os campos destacados.", fields=exc.errors), 400


def _resource(name):
    res = RESOURCES.get(name)
    if not res:
        abort(404, description="Recurso não encontrado.")
    return res


def _get_row(res, item_id):
    row = query_one(f"SELECT * FROM {res.table} WHERE id = %s", (item_id,))
    if not row:
        abort(404, description="Registro não encontrado.")
    return row


def _write(sql, params):
    try:
        return execute(sql, params)
    except pymysql.err.IntegrityError as exc:
        if exc.args and exc.args[0] == 1452:
            raise ValidationError({"category_id": "Categoria inexistente."})
        raise ValidationError({"_": "Registro duplicado ou em uso por outro item."})


# ---------- Resumo ----------
@bp.get("/summary")
def summary():
    counts = {}
    for name, res in RESOURCES.items():
        counts[name] = query_one(f"SELECT COUNT(*) AS total FROM {res.table}")["total"]
    return jsonify(counts=counts, user=g.user)


# ---------- Perfil (registro único) ----------
@bp.get("/profile")
def get_profile():
    row = query_one("SELECT * FROM profile WHERE id = 1")
    return jsonify(PROFILE.serialize(row) or {})


@bp.put("/profile")
def update_profile():
    data = PROFILE.validate(request.get_json(silent=True))
    columns = list(data)
    assignments = ", ".join(f"{c} = %s" for c in columns)
    placeholders = ", ".join(["%s"] * len(columns))
    _write(
        f"INSERT INTO profile (id, {', '.join(columns)}) VALUES (1, {placeholders}) "
        f"ON DUPLICATE KEY UPDATE {assignments}",
        [data[c] for c in columns] * 2,
    )
    return get_profile()


# ---------- CRUD genérico ----------
@bp.get("/<name>")
def list_items(name):
    res = _resource(name)
    rows = query_all(f"SELECT * FROM {res.table} ORDER BY {res.order_by}")
    return jsonify([res.serialize(r) for r in rows])


@bp.get("/<name>/<int:item_id>")
def get_item(name, item_id):
    res = _resource(name)
    return jsonify(res.serialize(_get_row(res, item_id)))


@bp.post("/<name>")
def create_item(name):
    res = _resource(name)
    data = res.validate(request.get_json(silent=True))
    columns = list(data)
    new_id, _ = _write(
        f"INSERT INTO {res.table} ({', '.join(columns)}) VALUES ({', '.join(['%s'] * len(columns))})",
        [data[c] for c in columns],
    )
    return jsonify(res.serialize(_get_row(res, new_id))), 201


@bp.put("/<name>/<int:item_id>")
def update_item(name, item_id):
    res = _resource(name)
    _get_row(res, item_id)
    data = res.validate(request.get_json(silent=True))
    columns = list(data)
    _write(
        f"UPDATE {res.table} SET {', '.join(f'{c} = %s' for c in columns)} WHERE id = %s",
        [data[c] for c in columns] + [item_id],
    )
    return jsonify(res.serialize(_get_row(res, item_id)))


@bp.delete("/<name>/<int:item_id>")
def delete_item(name, item_id):
    res = _resource(name)
    _get_row(res, item_id)
    _write(f"DELETE FROM {res.table} WHERE id = %s", (item_id,))
    return jsonify(ok=True)


# ---------- Upload de imagens ----------
@bp.post("/uploads")
def upload():
    file = request.files.get("file")
    if not file or not file.filename:
        return jsonify(error="Selecione uma imagem."), 400

    ext = file.filename.rsplit(".", 1)[-1].lower() if "." in file.filename else ""
    if ext not in IMAGE_SIGNATURES:
        return jsonify(error="Formato não suportado. Use PNG, JPG, GIF ou WEBP."), 400

    head = file.stream.read(16)
    file.stream.seek(0)
    if not any(head.startswith(sig) for sig in IMAGE_SIGNATURES[ext]):
        return jsonify(error="O arquivo não parece ser uma imagem válida."), 400

    upload_dir = current_app.config["UPLOAD_DIR"]
    upload_dir.mkdir(parents=True, exist_ok=True)
    filename = f"{uuid.uuid4().hex}.{'jpg' if ext == 'jpeg' else ext}"
    file.save(upload_dir / filename)
    return jsonify(url=f"/uploads/{filename}"), 201


# ---------- Conta ----------
@bp.put("/account/password")
def change_password():
    data = request.get_json(silent=True) or {}
    current = str(data.get("current_password", ""))
    new = str(data.get("new_password", ""))

    if len(new) < 8:
        raise ValidationError({"new_password": "A nova senha precisa ter pelo menos 8 caracteres."})

    row = query_one("SELECT password_hash FROM admin_users WHERE id = %s", (g.user["id"],))
    if not row or not check_password_hash(row["password_hash"], current):
        raise ValidationError({"current_password": "Senha atual incorreta."})

    execute("UPDATE admin_users SET password_hash = %s WHERE id = %s",
            (generate_password_hash(new), g.user["id"]))
    return jsonify(ok=True)
