# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.12

# ---------- Build stage ----------
FROM python:${PYTHON_VERSION}-slim AS build

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
# Cache mount keeps pip's cache out of the image, so --no-cache-dir is not needed
# hadolint ignore=DL3042
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

# ---------- Final image ----------
FROM python:${PYTHON_VERSION}-slim

LABEL org.opencontainers.image.title="fastapi-app" \
      org.opencontainers.image.version="1.0.0"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

RUN useradd --create-home --uid 10001 appuser

WORKDIR /app

COPY --from=build /opt/venv /opt/venv
COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
