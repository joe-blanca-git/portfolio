import pymysql
from flask import current_app, g


def connect(config):
    return pymysql.connect(
        host=config["DB_HOST"],
        port=config["DB_PORT"],
        user=config["DB_USER"],
        password=config["DB_PASSWORD"],
        database=config["DB_NAME"],
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=False,
        connect_timeout=5,
    )


def get_db():
    if "db" not in g:
        g.db = connect(current_app.config)
    return g.db


def close_db(exc=None):
    db = g.pop("db", None)
    if db is not None:
        if exc is not None:
            db.rollback()
        db.close()


def query_all(sql, params=()):
    with get_db().cursor() as cur:
        cur.execute(sql, params)
        return cur.fetchall()


def query_one(sql, params=()):
    with get_db().cursor() as cur:
        cur.execute(sql, params)
        return cur.fetchone()


def execute(sql, params=()):
    """Executa uma escrita e confirma na hora. Retorna (lastrowid, linhas afetadas)."""
    db = get_db()
    with db.cursor() as cur:
        cur.execute(sql, params)
        last_id, affected = cur.lastrowid, cur.rowcount
    db.commit()
    return last_id, affected
