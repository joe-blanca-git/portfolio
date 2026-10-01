"""Comandos utilitários.

  python manage.py testar-conexao
  python manage.py criar-admin
"""
import argparse
import getpass
import sys

from werkzeug.security import generate_password_hash

from config import Config
from db import connect


def _config():
    return {k: getattr(Config, k) for k in ("DB_HOST", "DB_PORT", "DB_USER", "DB_PASSWORD", "DB_NAME")}


def testar_conexao(_args):
    try:
        conn = connect(_config())
    except Exception as exc:  # noqa: BLE001
        print(f"Falha ao conectar em {Config.DB_HOST}:{Config.DB_PORT}/{Config.DB_NAME}: {exc}")
        return 1
    with conn.cursor() as cur:
        cur.execute("SHOW TABLES")
        tables = sorted(next(iter(row.values())) for row in cur.fetchall())
    conn.close()
    print(f"Conectado a {Config.DB_NAME}. Tabelas: {', '.join(tables) or '(nenhuma)'}")
    return 0


def criar_admin(args):
    email = (args.email or input("E-mail do admin: ")).strip().lower()
    name = (args.nome or input("Nome (opcional): ")).strip() or None
    password = args.senha or getpass.getpass("Senha (mín. 8 caracteres): ")
    if len(password) < 8:
        print("A senha precisa ter pelo menos 8 caracteres.")
        return 1
    if not args.senha and getpass.getpass("Confirme a senha: ") != password:
        print("As senhas não conferem.")
        return 1

    conn = connect(_config())
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO admin_users (email, name, password_hash) VALUES (%s, %s, %s) "
            "ON DUPLICATE KEY UPDATE name = VALUES(name), password_hash = VALUES(password_hash)",
            (email, name, generate_password_hash(password)),
        )
    conn.commit()
    conn.close()
    print(f"Admin {email} salvo.")
    return 0


def main():
    parser = argparse.ArgumentParser(description="Utilitários do backend do portfólio")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("testar-conexao", help="Testa a conexão com o MySQL").set_defaults(func=testar_conexao)

    p = sub.add_parser("criar-admin", help="Cria ou redefine a senha de um admin")
    p.add_argument("--email")
    p.add_argument("--nome")
    p.add_argument("--senha", help="Evite em produção: fica no histórico do terminal")
    p.set_defaults(func=criar_admin)

    args = parser.parse_args()
    sys.exit(args.func(args))


if __name__ == "__main__":
    main()
