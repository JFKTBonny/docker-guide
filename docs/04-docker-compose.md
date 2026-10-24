# 4. Docker Compose

Compose defines multiple containers, their networks and volumes in one file.
All services in a Compose file share a network and reach each other by service name.

## Example `compose.yaml`

A ready-to-use version lives in [compose/app-with-postgres](../compose/app-with-postgres).

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://postgres:secret@db:5432/postgres
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

volumes:
  pgdata:
```

## Commands

```bash
# Start everything in the background
docker compose up -d

# Rebuild images, then start
docker compose up -d --build

# See status
docker compose ps

# Follow logs for all services
docker compose logs -f

# Follow logs for one service
docker compose logs -f app

# Shell into a service
docker compose exec app sh

# Run a one-off command
docker compose run --rm app npm test

# Restart one service
docker compose restart app

# Stop and remove containers and the network
docker compose down

# Also remove volumes (deletes data!)
docker compose down -v
```

## Useful keys

| Key | Purpose |
|-----|---------|
| `build` | Build from a Dockerfile instead of pulling an image |
| `image` | Image to use |
| `ports` | `"host:container"` port mapping |
| `environment` / `env_file` | Environment variables |
| `volumes` | Named volumes or bind mounts |
| `depends_on` | Start order (with `condition: service_healthy` to wait for readiness) |
| `restart` | `no`, `always`, `on-failure`, `unless-stopped` |
| `healthcheck` | Command that checks whether the service works |
| `init` | `true` adds an init process for clean shutdowns |

---

Previous: [Volumes and Networks](03-volumes-and-networks.md) | Next: [Cleanup and Troubleshooting](05-cleanup-and-troubleshooting.md)
