# Python: Django

Runs Django with Gunicorn.

## Requirements

`requirements.txt` must include:

```
django
gunicorn
```

In `settings.py`:

```python
import os

STATIC_ROOT = BASE_DIR / "staticfiles"
ALLOWED_HOSTS = os.environ.get("DJANGO_ALLOWED_HOSTS", "localhost").split(",")
```

To serve static files without a separate web server, add `whitenoise` to
`requirements.txt` and to `MIDDLEWARE` (right after `SecurityMiddleware`):

```python
"whitenoise.middleware.WhiteNoiseMiddleware",
```

## Before building

In the Dockerfile, replace `myproject` with the folder that contains `wsgi.py`.

`collectstatic` runs during the build, so `settings.py` must load without
runtime secrets. Give environment variables safe defaults, for example:

```python
SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY", "build-only-not-secret")
```

Then pass the real value at runtime with `-e DJANGO_SECRET_KEY=...`.

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t django-app .
docker run -d --name django-app -p 8000:8000 -e DJANGO_ALLOWED_HOSTS=localhost django-app
```

Run migrations:

```bash
docker exec -it django-app python manage.py migrate
```

Create an admin user:

```bash
docker exec -it django-app python manage.py createsuperuser
```

Open http://localhost:8000
