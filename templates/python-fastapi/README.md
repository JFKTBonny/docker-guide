# Python: FastAPI

## Requirements

`requirements.txt` must include:

```
fastapi
uvicorn[standard]
```

Entry point is assumed to be `main.py` with a variable named `app`.
Change `main:app` in the `CMD` line if yours is different.

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t fastapi-app .
docker run -d --name fastapi-app -p 8000:8000 fastapi-app
```

Open http://localhost:8000/docs

## Multiple workers

```dockerfile
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```
