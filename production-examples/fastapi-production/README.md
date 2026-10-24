# FastAPI: Production Dockerfile

Applies every practice from [Dockerfile Best Practices](../../docs/06-dockerfile-best-practices.md):

- Pinned Python version via `ARG`
- Multi-stage build: dependencies installed into a virtualenv, copied into a clean image
- BuildKit cache mount for faster `pip install`
- Runs as non-root `appuser` (UID 10001)
- `HEALTHCHECK` against `/health` (no curl needed)
- OCI labels

## Requirements

`requirements.txt` must include:

```
fastapi
uvicorn[standard]
```

`main.py` must define `app` and a health endpoint:

```python
from fastapi import FastAPI

app = FastAPI()


@app.get("/health")
def health():
    return {"status": "ok"}
```

## Usage

```bash
docker build -t fastapi-app:1.0 .
docker run -d --init --name fastapi-app -p 8000:8000 --env-file .env fastapi-app:1.0
```

Check health:

```bash
docker inspect --format='{{.State.Health.Status}}' fastapi-app
```
