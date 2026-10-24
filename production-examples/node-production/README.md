# Node.js: Production Dockerfile

Applies every practice from [Dockerfile Best Practices](../../docs/06-dockerfile-best-practices.md):

- Pinned base image version via `ARG`
- Three stages: build, production dependencies, final image
- BuildKit cache mounts for faster `npm ci`
- Runs as the built-in non-root `node` user
- `tini` as init process for clean shutdowns
- `HEALTHCHECK` against `/health`
- OCI labels

## Requirements

- `npm run build` outputs to `dist/`, with entry file `dist/server.js`
- The app exposes a `GET /health` endpoint that returns HTTP 200

## Usage

```bash
docker build -t myapp:1.0 .
docker run -d --name myapp -p 3000:3000 --env-file .env myapp:1.0
```

Check health:

```bash
docker inspect --format='{{.State.Health.Status}}' myapp
```
