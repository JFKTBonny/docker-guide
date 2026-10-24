# PHP: Laravel (Apache)

Runs Laravel on PHP 8.3 with Apache, pointing the web root at `public/`.

## Requirements

- `composer.json` and `composer.lock` in the project root
- For PostgreSQL instead of MySQL, change `pdo_mysql` to `pdo_pgsql` and add `libpq-dev` to the `apt-get install` list

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t laravel-app .
docker run -d --name laravel-app -p 8080:80 --env-file .env laravel-app
```

Generate an app key (if not already in `.env`):

```bash
docker exec -it laravel-app php artisan key:generate --show
```

Run migrations:

```bash
docker exec -it laravel-app php artisan migrate --force
```

Cache config and routes for production:

```bash
docker exec -it laravel-app php artisan config:cache
docker exec -it laravel-app php artisan route:cache
```

Open http://localhost:8080
