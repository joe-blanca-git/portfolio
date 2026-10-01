import os
import secrets
from pathlib import Path

from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent
load_dotenv(BASE_DIR / ".env")


def _bool(name, default=False):
    value = os.getenv(name)
    if value is None:
        return default
    return value.strip().lower() in ("1", "true", "yes", "on")


class Config:
    DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
    DB_PORT = int(os.getenv("DB_PORT", "3306"))
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_NAME = os.getenv("DB_NAME", "portfolio")

    SECRET_KEY = os.getenv("SECRET_KEY") or ""
    TOKEN_HOURS = int(os.getenv("TOKEN_HOURS", "12"))

    HOST = os.getenv("HOST", "127.0.0.1")
    PORT = int(os.getenv("PORT", "5000"))
    DEBUG = _bool("DEBUG", False)

    CORS_ORIGINS = [o.strip() for o in os.getenv("CORS_ORIGINS", "*").split(",") if o.strip()]

    # Endereço público do site, usado em canonical, Open Graph e sitemap
    SITE_URL = os.getenv("SITE_URL", "").strip().rstrip("/")

    SERVE_FRONTEND = _bool("SERVE_FRONTEND", True)
    FRONTEND_DIR = Path(os.getenv("FRONTEND_DIR", BASE_DIR.parent / "frontend")).resolve()

    UPLOAD_DIR = Path(os.getenv("UPLOAD_DIR", BASE_DIR / "uploads")).resolve()
    MAX_UPLOAD_MB = int(os.getenv("MAX_UPLOAD_MB", "5"))
    MAX_CONTENT_LENGTH = MAX_UPLOAD_MB * 1024 * 1024

    JSON_AS_ASCII = False


def ensure_secret_key(config):
    """Sem SECRET_KEY no .env, gera uma temporária (os logins expiram a cada reinício)."""
    if not config.get("SECRET_KEY"):
        config["SECRET_KEY"] = secrets.token_hex(32)
        print("[aviso] SECRET_KEY não definida no .env; usando uma chave temporária.")
