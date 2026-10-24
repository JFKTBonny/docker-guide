# React (Vite), served by Nginx

Builds the app with Node, then serves the static files with Nginx.
The final image contains no Node.js, only Nginx and your built files.

## Requirements

- A Vite project (`npm run build` outputs to `dist/`)
- `package-lock.json` in the project root

For **Create React App**, change `/app/dist` to `/app/build` in the Dockerfile.

## Usage

Copy `Dockerfile`, `nginx.conf` and `.dockerignore` into your project root, then:

```bash
docker build -t react-app .
docker run -d --name react-app -p 8080:80 react-app
```

Open http://localhost:8080

## Environment variables

Vite bakes `VITE_*` variables in at **build** time. Pass them as build args:

```dockerfile
# Add above "RUN npm run build" in the build stage
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
```

```bash
docker build --build-arg VITE_API_URL=https://api.example.com -t react-app .
```
