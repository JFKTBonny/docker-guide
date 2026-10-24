# Angular, served by Nginx

Builds the app with Node, then serves the static files with Nginx.

## Requirements

- Angular 17 or newer (output in `dist/<project>/browser`)
- `package-lock.json` in the project root

## Before building

1. In the Dockerfile, replace `my-app` with your project name from `angular.json`.
2. For Angular 16 or older, remove `/browser` from the path.

## Usage

Copy `Dockerfile`, `nginx.conf` and `.dockerignore` into your project root, then:

```bash
docker build -t angular-app .
docker run -d --name angular-app -p 8080:80 angular-app
```

Open http://localhost:8080
