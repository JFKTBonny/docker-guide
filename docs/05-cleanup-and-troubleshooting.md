# 5. Cleanup and Troubleshooting

## Cleanup

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes (deletes data!)
docker volume prune

# Remove unused networks
docker network prune

# Remove everything unused at once
docker system prune -a

# Check disk usage
docker system df
```

## Troubleshooting

### Container exits immediately

```bash
docker ps -a
docker logs CONTAINER_NAME
```

### Port already in use

Find what is using the port (Linux/macOS):

```bash
sudo lsof -i :8080
```

Or map a different host port:

```bash
docker run -d -p 8081:80 nginx:latest
```

### Permission denied on Linux

Add your user to the docker group, then log out and back in:

```bash
sudo usermod -aG docker $USER
```

### Debug a failing image

Override its start command and look around:

```bash
docker run --rm -it --entrypoint sh myapp:1.0
```

### Build uses old code

```bash
docker build --no-cache -t myapp:1.0 .
```

### Container cannot reach another container

Make sure both are on the same user-defined network and use the container name as the hostname:

```bash
docker network inspect mynet
```

### Check container health

```bash
docker inspect --format='{{.State.Health.Status}}' CONTAINER_NAME
```

---

Previous: [Docker Compose](04-docker-compose.md) | Next: [Dockerfile Best Practices](06-dockerfile-best-practices.md)
