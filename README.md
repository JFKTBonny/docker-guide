# Docker Guide

A practical Docker reference: core concepts, commands, production-ready
Dockerfile templates for popular frameworks, and best practices.
Every example is complete and ready to copy and paste.

## Documentation

1. [Core Concepts](docs/01-core-concepts.md)
2. [Images and Containers](docs/02-images-and-containers.md)
3. [Volumes and Networks](docs/03-volumes-and-networks.md)
4. [Docker Compose](docs/04-docker-compose.md)
5. [Cleanup and Troubleshooting](docs/05-cleanup-and-troubleshooting.md)
6. [Dockerfile Best Practices](docs/06-dockerfile-best-practices.md)

## Dockerfile Templates

| Framework | Template | Default port |
|-----------|----------|--------------|
| Node.js (Express) | [templates/node-express](templates/node-express) | 3000 |
| React (Vite) | [templates/react-vite](templates/react-vite) | 80 |
| Angular | [templates/angular](templates/angular) | 80 |
| Next.js | [templates/nextjs](templates/nextjs) | 3000 |
| FastAPI | [templates/python-fastapi](templates/python-fastapi) | 8000 |
| Flask | [templates/python-flask](templates/python-flask) | 5000 |
| Django | [templates/python-django](templates/python-django) | 8000 |
| Spring Boot (Maven) | [templates/java-spring-maven](templates/java-spring-maven) | 8080 |
| Spring Boot (Gradle) | [templates/java-spring-gradle](templates/java-spring-gradle) | 8080 |
| ASP.NET Core | [templates/dotnet](templates/dotnet) | 8080 |
| Go | [templates/go](templates/go) | 8080 |
| Laravel | [templates/php-laravel](templates/php-laravel) | 80 |
| Ruby on Rails | [templates/ruby-rails](templates/ruby-rails) | 3000 |

## Production Examples

Complete Dockerfiles with every best practice applied:

- [Node.js](production-examples/node-production)
- [FastAPI](production-examples/fastapi-production)

## Compose

- [App + PostgreSQL](compose/app-with-postgres)

## How to Use a Template

1. Copy the template's `Dockerfile` and `.dockerignore` (plus `nginx.conf` for React/Angular) into your project root.
2. Replace any placeholder values noted in the template's README (project names, entry files).
3. Build and run:

```bash
docker build -t myapp .
docker run -d --name myapp -p 8080:8080 myapp
```

## Repository Structure

```
docker-guide/
├── docs/                    Step-by-step guide
├── templates/               One Dockerfile per framework
├── production-examples/     Fully hardened Dockerfiles
├── compose/                 Multi-container setups
├── scripts/                 Helper scripts
└── .github/workflows/       CI: lints every Dockerfile on push
```

## Lint All Dockerfiles Locally

```bash
./scripts/lint-all.sh
```

Requires Docker. Uses [Hadolint](https://github.com/hadolint/hadolint) with the rules in `.hadolint.yaml`.

## License

[MIT](LICENSE)
