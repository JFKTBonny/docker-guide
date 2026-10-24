# 6. Dockerfile Best Practices

Complete Dockerfiles with every practice applied are in [production-examples](../production-examples).

## Contents

1. [Pin base image versions](#1-pin-base-image-versions)
2. [Use small base images](#2-use-small-base-images)
3. [Use multi-stage builds](#3-use-multi-stage-builds)
4. [Order layers for caching](#4-order-layers-for-caching)
5. [Combine RUN commands and clean up](#5-combine-run-commands-and-clean-up-in-the-same-layer)
6. [Use BuildKit cache mounts](#6-use-buildkit-cache-mounts-for-faster-rebuilds)
7. [Always use a .dockerignore](#7-always-use-a-dockerignore)
8. [Run as a non-root user](#8-run-as-a-non-root-user)
9. [Never put secrets in the image](#9-never-put-secrets-in-the-image)
10. [Use COPY, not ADD](#10-use-copy-not-add)
11. [Use exec form for CMD and ENTRYPOINT](#11-use-exec-form-for-cmd-and-entrypoint)
12. [Handle signals and zombie processes](#12-handle-signals-and-zombie-processes)
13. [Add a HEALTHCHECK](#13-add-a-healthcheck)
14. [Use lockfiles](#14-use-lockfiles-and-deterministic-installs)
15. [ARG vs ENV](#15-arg-vs-env)
16. [Add labels](#16-add-labels-metadata)
17. [One process per container](#17-one-process-per-container)
18. [Lint and scan your images](#18-lint-and-scan-your-images)
19. [Checklist](#checklist)

## 1. Pin Base Image Versions

Floating tags like `latest` change without warning and can break builds.

```dockerfile
# Bad
FROM node:latest

# Good: specific version
FROM node:20.18-alpine3.20

# Best for production: pin to an exact digest
FROM node:20.18-alpine3.20@sha256:REPLACE_WITH_DIGEST
```

Get the digest:

```bash
docker pull node:20.18-alpine3.20
docker inspect --format='{{index .RepoDigests 0}}' node:20.18-alpine3.20
```

## 2. Use Small Base Images

Smaller images build faster, pull faster and have fewer vulnerabilities.

```dockerfile
# Large (~1 GB)
FROM python:3.12

# Small (~130 MB)
FROM python:3.12-slim

# Smallest for compiled languages (Go, Rust): no shell, no package manager
FROM gcr.io/distroless/static-debian12:nonroot
```

## 3. Use Multi-Stage Builds

Build tools stay in the first stage; only the result goes into the final image.

```dockerfile
# Build stage: has compilers and dev dependencies
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Final stage: only what is needed to run
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
CMD ["node", "dist/server.js"]
```

## 4. Order Layers for Caching

Docker reuses cached layers until something changes. Put what changes least at the top.

```dockerfile
# Bad: any code change reinstalls all dependencies
COPY . .
RUN npm ci
```

```dockerfile
# Good: dependencies are reinstalled only when package files change
COPY package*.json ./
RUN npm ci
COPY . .
```

## 5. Combine RUN Commands and Clean Up in the Same Layer

Each `RUN` creates a layer. Files deleted in a later layer still take up space.

```dockerfile
# Bad: package cache stays in the image
RUN apt-get update
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*
```

```dockerfile
# Good: one layer, cache removed
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*
```

For Alpine:

```dockerfile
RUN apk add --no-cache curl ca-certificates
```

For pip:

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt
```

## 6. Use BuildKit Cache Mounts for Faster Rebuilds

Keeps the package manager cache between builds without putting it in the image.
Add `# syntax=docker/dockerfile:1` as the first line of the Dockerfile.

```dockerfile
# syntax=docker/dockerfile:1

# Node
RUN --mount=type=cache,target=/root/.npm npm ci

# Python
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

# Go
RUN --mount=type=cache,target=/go/pkg/mod go mod download

# Maven
RUN --mount=type=cache,target=/root/.m2 mvn package -DskipTests -B
```

## 7. Always Use a .dockerignore

Keeps secrets, dependencies and junk out of the build context.

```
.git
.gitignore
.env
.env.*
node_modules
__pycache__
*.log
Dockerfile
docker-compose*.yml
compose*.yaml
README.md
.vscode
.idea
```

## 8. Run as a Non-Root User

If the app is compromised, the attacker doesn't get root inside the container.

Node images already include a `node` user:

```dockerfile
COPY --chown=node:node . .
USER node
```

Debian/Ubuntu-based images (e.g. `python:3.12-slim`):

```dockerfile
RUN useradd --create-home --uid 10001 appuser
COPY --chown=appuser:appuser . .
USER appuser
```

Alpine-based images:

```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --chown=appuser:appgroup . .
USER appuser
```

## 9. Never Put Secrets in the Image

Anything in `ENV`, `ARG` or a copied file can be read from the image history.

```dockerfile
# Bad: token is permanently stored in the image
ENV NPM_TOKEN=abc123
ARG DB_PASSWORD=secret
COPY .env .
```

Good: use a BuildKit secret mount, available only during that one `RUN`:

```dockerfile
# syntax=docker/dockerfile:1
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm ci
```

```bash
docker build --secret id=npmrc,src=$HOME/.npmrc -t myapp .
```

Runtime secrets are passed when the container starts, not baked in:

```bash
docker run -d --env-file .env myapp
```

## 10. Use COPY, Not ADD

`ADD` can download URLs and auto-extract archives, which is surprising behavior. Use it only when you specifically need extraction.

```dockerfile
# Good
COPY src/ ./src/

# Only when you want a local tar file extracted
ADD app.tar.gz /opt/app/
```

## 11. Use Exec Form for CMD and ENTRYPOINT

Exec form (JSON array) lets your app receive stop signals, so containers shut down cleanly.

```dockerfile
# Bad: runs under /bin/sh, app may not receive SIGTERM
CMD node server.js
```

```dockerfile
# Good
CMD ["node", "server.js"]
```

Combine `ENTRYPOINT` (fixed command) with `CMD` (default, overridable arguments):

```dockerfile
ENTRYPOINT ["python", "app.py"]
CMD ["--port", "8000"]
```

```bash
# Uses default args
docker run myapp

# Overrides only the CMD args
docker run myapp --port 9000
```

## 12. Handle Signals and Zombie Processes

Run with a tiny init process so signals are forwarded and child processes are cleaned up.

```bash
docker run --init -d myapp
```

In Compose:

```yaml
services:
  app:
    build: .
    init: true
```

Or build it into the image (Alpine):

```dockerfile
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "server.js"]
```

## 13. Add a HEALTHCHECK

Lets Docker know whether the app is actually working, not just running.

Alpine images (have `wget`):

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
```

Python slim images (no curl or wget by default):

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1
```

Check status:

```bash
docker ps
docker inspect --format='{{.State.Health.Status}}' CONTAINER_NAME
```

## 14. Use Lockfiles and Deterministic Installs

```dockerfile
# Node: npm ci uses package-lock.json exactly
RUN npm ci

# Yarn
RUN yarn install --frozen-lockfile

# pnpm
RUN corepack enable && pnpm install --frozen-lockfile

# Python: pin versions in requirements.txt (e.g. fastapi==0.115.0)
RUN pip install --no-cache-dir -r requirements.txt
```

## 15. ARG vs ENV

- `ARG`: available only at build time.
- `ENV`: available at build time and in the running container.

```dockerfile
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine

ARG APP_VERSION=1.0.0
ENV NODE_ENV=production
ENV APP_VERSION=${APP_VERSION}
```

```bash
docker build --build-arg NODE_VERSION=22 --build-arg APP_VERSION=2.1.0 -t myapp .
```

## 16. Add Labels (Metadata)

```dockerfile
LABEL org.opencontainers.image.title="myapp" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/youruser/myapp" \
      org.opencontainers.image.description="My application"
```

## 17. One Process per Container

Run the web app, database and worker as separate containers, connected with Compose, rather than one container running everything.

```yaml
services:
  web:
    build: .
    command: ["node", "server.js"]
  worker:
    build: .
    command: ["node", "worker.js"]
  db:
    image: postgres:16
```

## 18. Lint and Scan Your Images

Lint the Dockerfile with Hadolint:

```bash
docker run --rm -i hadolint/hadolint < Dockerfile
```

Lint every Dockerfile in this repo:

```bash
./scripts/lint-all.sh
```

Scan for vulnerabilities with Docker Scout:

```bash
docker scout quickview myapp:1.0
docker scout cves myapp:1.0
```

Or with Trivy:

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image myapp:1.0
```

Check image size and layers:

```bash
docker images myapp
docker history myapp:1.0
```

## Checklist

- [ ] Base image pinned to a specific version, small variant (`-alpine`, `-slim`, distroless)
- [ ] Multi-stage build separates build tools from runtime
- [ ] Dependency files copied and installed before source code
- [ ] `RUN` commands combined, caches cleaned in the same layer
- [ ] `.dockerignore` present, `.env` and `.git` excluded
- [ ] Runs as a non-root user
- [ ] No secrets in `ENV`, `ARG` or copied files
- [ ] `COPY` instead of `ADD`
- [ ] `CMD`/`ENTRYPOINT` in exec (JSON array) form
- [ ] `--init` or tini for signal handling
- [ ] `HEALTHCHECK` defined
- [ ] Lockfiles used for reproducible installs
- [ ] Image linted (Hadolint) and scanned (Docker Scout or Trivy)

---

Previous: [Cleanup and Troubleshooting](05-cleanup-and-troubleshooting.md) | Back to [README](../README.md)
