import pymysql
from flask import Flask, Response, abort, jsonify, request, send_from_directory
from flask_cors import CORS
from werkzeug.exceptions import HTTPException, NotFound

import api_admin
import api_public
import auth
import seo
from config import Config, ensure_secret_key
from db import close_db

# Páginas que recebem meta tags geradas no servidor
SEO_PAGES = {"index.html", "service-details.html"}


def create_app():
    app = Flask(__name__, static_folder=None)
    app.config.from_object(Config)
    ensure_secret_key(app.config)

    CORS(app, resources={r"/api/*": {"origins": app.config["CORS_ORIGINS"]}})
    app.teardown_appcontext(close_db)

    app.register_blueprint(api_public.bp)
    app.register_blueprint(auth.bp)
    app.register_blueprint(api_admin.bp)

    @app.get("/uploads/<path:filename>")
    def uploaded_file(filename):
        return send_from_directory(app.config["UPLOAD_DIR"], filename, max_age=60 * 60 * 24 * 30)

    @app.get("/robots.txt")
    def robots():
        return Response(seo.robots_txt(), mimetype="text/plain")

    @app.get("/sitemap.xml")
    def sitemap():
        return Response(seo.sitemap_xml(), mimetype="application/xml")

    if app.config["SERVE_FRONTEND"]:
        frontend = app.config["FRONTEND_DIR"]

        def html_page(name):
            raw = (frontend / name).read_text(encoding="utf-8")
            return Response(seo.render_page(name, raw), mimetype="text/html")

        @app.get("/")
        def index():
            return html_page("index.html")

        @app.get("/<path:path>")
        def static_files(path):
            if path.startswith("api/"):
                abort(404)
            if path in SEO_PAGES:
                return html_page(path)
            return send_from_directory(frontend, path)

    @app.errorhandler(HTTPException)
    def http_error(exc):
        if request.path.startswith("/api/"):
            message = exc.description
            if exc.code == 404 and message == NotFound.description:
                message = "Rota não encontrada."
            return jsonify(error=message), exc.code
        return exc

    @app.errorhandler(pymysql.err.OperationalError)
    def database_unavailable(exc):
        app.logger.error("Banco de dados indisponível: %s", exc)
        return jsonify(error="Banco de dados indisponível no momento."), 503

    @app.errorhandler(Exception)
    def unexpected_error(exc):
        app.logger.exception("Erro não tratado")
        if request.path.startswith("/api/"):
            return jsonify(error="Erro interno no servidor."), 500
        raise exc

    return app


app = create_app()

if __name__ == "__main__":
    app.run(host=app.config["HOST"], port=app.config["PORT"], debug=app.config["DEBUG"])
