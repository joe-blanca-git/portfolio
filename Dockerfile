FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY backend/requirements.txt backend/requirements.txt
RUN pip install -r backend/requirements.txt gunicorn==23.0.0

COPY backend/ backend/
COPY frontend/ frontend/

# Usuário sem privilégios; a pasta de uploads vira volume persistente
RUN useradd --system --uid 10001 --no-create-home app \
    && mkdir -p backend/uploads \
    && chown -R app:app backend/uploads

USER app
WORKDIR /app/backend
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:8000/api/health', timeout=4).status == 200 else 1)"

CMD ["gunicorn", "--workers", "2", "--threads", "4", "--bind", "0.0.0.0:8000", \
     "--forwarded-allow-ips", "*", "--access-logfile", "-", "app:app"]
