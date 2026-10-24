# 2. Images and Containers

## Images

```bash
# Download an image
docker pull nginx:latest

# List local images
docker images

# Remove an image
docker rmi nginx:latest

# Build an image from a Dockerfile in the current folder
docker build -t myapp:1.0 .

# Build without cache
docker build --no-cache -t myapp:1.0 .

# Show the layers of an image
docker history myapp:1.0
```

### Push to Docker Hub

```bash
docker login
docker tag myapp:1.0 yourusername/myapp:1.0
docker push yourusername/myapp:1.0
```

## Containers

```bash
# Run nginx in the background, mapping host port 8080 to container port 80
docker run -d --name web -p 8080:80 nginx:latest

# List running containers
docker ps

# List all containers, including stopped ones
docker ps -a

# Stop, start, restart
docker stop web
docker start web
docker restart web

# Remove a container
docker rm web

# Force-remove a running container
docker rm -f web
```

### Logs, shell access and inspection

```bash
# View logs
docker logs web

# Follow live logs
docker logs -f web

# Open a shell inside a running container
docker exec -it web bash

# If bash is missing (e.g. Alpine images), use sh
docker exec -it web sh

# Inspect full container details
docker inspect web

# Live resource usage
docker stats
```

### Useful run options

```bash
# Throwaway container that deletes itself on exit
docker run --rm -it ubuntu:24.04 bash

# Pass environment variables
docker run -d --name db -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres:16

# Load environment variables from a file
docker run -d --name app --env-file .env -p 3000:3000 myapp:1.0

# Restart automatically unless stopped manually
docker run -d --name web --restart unless-stopped -p 8080:80 nginx:latest

# Limit memory and CPU
docker run -d --name web --memory 512m --cpus 1.0 -p 8080:80 nginx:latest

# Run with an init process (clean signal handling)
docker run -d --init --name app -p 3000:3000 myapp:1.0
```

---

Previous: [Core Concepts](01-core-concepts.md) | Next: [Volumes and Networks](03-volumes-and-networks.md)
