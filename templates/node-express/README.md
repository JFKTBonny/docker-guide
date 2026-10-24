# Node.js (Express)

## Requirements

- `package.json` and `package-lock.json` in the project root
- Entry file `server.js` (change the `CMD` line if yours is different)
- App listens on port `3000`

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t express-app .
docker run -d --name express-app -p 3000:3000 express-app
```

Open http://localhost:3000
