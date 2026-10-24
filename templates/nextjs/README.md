# Next.js

Uses Next.js **standalone** output, which bundles only the files needed to run,
giving a much smaller image.

## Requirements

Add this to `next.config.js`:

```js
module.exports = {
  output: "standalone",
};
```

Or, for `next.config.mjs`:

```js
const nextConfig = {
  output: "standalone",
};

export default nextConfig;
```

A `public/` folder must exist (it can be empty).

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t next-app .
docker run -d --name next-app -p 3000:3000 next-app
```

Open http://localhost:3000
