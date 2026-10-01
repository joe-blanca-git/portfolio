import time
from functools import wraps

from flask import Blueprint, current_app, g, jsonify, request
from itsdangerous import BadSignature, SignatureExpired, URLSafeTimedSerializer
from werkzeug.security import check_password_hash

from db import execute, query_one

bp = Blueprint("auth", __name__, url_prefix="/api/auth")


def _serializer():
    return URLSafeTimedSerializer(current_app.config["SECRET_KEY"], salt="portfolio-admin")


def create_token(user_id):
    return _serializer().dumps({"uid": user_id})


def current_user():
    header = request.headers.get("Authorization", "")
    if not header.startswith("Bearer "):
        return None
    token = header[7:].strip()
    max_age = current_app.config["TOKEN_HOURS"] * 3600
    try:
        data = _serializer().loads(token, max_age=max_age)
    except (BadSignature, SignatureExpired):
        return None
    return query_one("SELECT id, email, name FROM admin_users WHERE id = %s", (data.get("uid"),))


def login_required(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        user = current_user()
        if not user:
            return jsonify(error="Sessão expirada. Faça login novamente."), 401
        g.user = user
        return fn(*args, **kwargs)
    return wrapper


@bp.post("/login")
def login():
    data = request.get_json(silent=True) or {}
    email = str(data.get("email", "")).strip().lower()
    password = str(data.get("password", ""))

    if not email or not password:
        return jsonify(error="Informe e-mail e senha."), 400

    user = query_one("SELECT id, email, name, password_hash FROM admin_users WHERE email = %s", (email,))
    if not user or not check_password_hash(user["password_hash"], password):
        time.sleep(0.6)  # desacelera tentativas de força bruta
        return jsonify(error="E-mail ou senha inválidos."), 401

    execute("UPDATE admin_users SET last_login_at = NOW() WHERE id = %s", (user["id"],))
    return jsonify(
        token=create_token(user["id"]),
        user={"id": user["id"], "email": user["email"], "name": user["name"]},
        expires_in=current_app.config["TOKEN_HOURS"] * 3600,
    )


@bp.get("/me")
@login_required
def me():
    return jsonify(user=g.user)
