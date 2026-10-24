# Compose: App + PostgreSQL

Runs your app next to a PostgreSQL database with:

- A named volume so database data survives restarts
- A health check, so the app starts only once the database is ready
- Credentials loaded from `.env` (never committed)

## Usage

1. Copy `compose.yaml` and `.env.example` into your project root (next to your `Dockerfile`).
2. Create your `.env` and set a real password:

```bash
cp .env.example .env
```

3. Start everything:

```bash
docker compose up -d --build
```

Inside the app, the database is reachable at host `db`, port `5432`.
The full connection string is in the `DATABASE_URL` environment variable.

## Common commands

```bash
docker compose ps
docker compose logs -f app
docker compose exec db psql -U postgres -d appdb
docker compose down
```

Delete the database data too:

```bash
docker compose down -v
```

## Change the app port

Edit the `ports` line in `compose.yaml`, for example `"8000:8000"` for FastAPI or Django.
