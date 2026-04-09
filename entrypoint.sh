#!/bin/bash
set -e

# Wait for DB if needed (simple check)
if [ "$DB_CONNECTION" = "pgsql" ] || [ "$DB_CONNECTION" = "mysql" ]; then
  echo "Waiting for database..."
  until php artisan migrate:status > /dev/null 2>&1; do
    echo "DB not ready, waiting..."
    sleep 2
  done
fi

# Generate app key if not set
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
  php artisan key:generate --force --no-interaction --quiet
  export APP_KEY=$(php artisan config:show app.key --quiet)
  echo "Generated APP_KEY"
fi

# Run migrations
php artisan migrate --force --no-interaction --quiet

# Create storage link if missing
php artisan storage:link || true

# Cache configs (use env)
php artisan config:cache --quiet
php artisan route:cache --quiet
php artisan view:cache --quiet

# Start Apache
exec apache2-foreground
