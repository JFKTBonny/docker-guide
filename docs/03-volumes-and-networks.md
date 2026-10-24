# 3. Volumes and Networks

## Volumes (persistent data)

Data written inside a container is lost when the container is removed. Volumes keep it.

```bash
# Create a named volume
docker volume create pgdata

# Use it in a container
docker run -d --name db \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16

# List volumes
docker volume ls

# Inspect a volume
docker volume inspect pgdata

# Remove a volume (deletes its data!)
docker volume rm pgdata
```

### Bind mounts (map a host folder into the container)

Good for development: edits on your machine appear instantly in the container.

```bash
docker run -d --name web \
  -v "$(pwd)/html:/usr/share/nginx/html:ro" \
  -p 8080:80 \
  nginx:latest
```

`:ro` makes the mount read-only inside the container.

| Type | Syntax | Use for |
|------|--------|---------|
| Named volume | `-v pgdata:/path` | Databases, persistent app data |
| Bind mount | `-v /host/path:/path` | Development, config files |

## Networks

Containers on the same user-defined network can reach each other **by container name**.

```bash
# Create a network
docker network create mynet

# Run two containers on it
docker run -d --name db --network mynet -e POSTGRES_PASSWORD=secret postgres:16
docker run -d --name app --network mynet -p 3000:3000 myapp:1.0

# Inside "app", the database is reachable at hostname "db", port 5432

# List networks
docker network ls

# Inspect a network
docker network inspect mynet

# Connect an existing container to a network
docker network connect mynet some-container

# Remove a network
docker network rm mynet
```

---

Previous: [Images and Containers](02-images-and-containers.md) | Next: [Docker Compose](04-docker-compose.md)
