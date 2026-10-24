# Python: Flask

Runs Flask with Gunicorn, a production-grade server (never use `flask run` in production).

## Requirements

`requirements.txt` must include:

```
flask
gunicorn
```

Entry point is assumed to be `app.py` with a variable named `app`.
Change `app:app` in the `CMD` line if yours is different.

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t flask-app .
docker run -d --name flask-app -p 5000:5000 flask-app
```

Open http://localhost:5000
