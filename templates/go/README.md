# Go (Gin, Echo, Fiber or standard library)

Compiles a static binary, then runs it on a distroless image
(no shell, no package manager, a few MB in size).

## Requirements

- `go.mod` and `go.sum` in the project root
- `main` package in the project root (if it is in `cmd/server`, change `.` to `./cmd/server` in the build line)
- App listens on port `8080`

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t go-app .
docker run -d --name go-app -p 8080:8080 go-app
```

Open http://localhost:8080

## Debugging

Distroless has no shell. To debug, temporarily change the final image to:

```dockerfile
FROM alpine:3.20
```
