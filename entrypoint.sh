#!/bin/bash
set -e

# Ensure Laravel writable directories exist before any Artisan cache commands run.
mkdir -p storage/framework/views storage/framework/cache storage/framework/sessions bootstrap/cache
chown -R www-data:www-data /var/www/html
chmod -R 777 storage bootstrap/cache

# Wait for DB if needed (simple check)
if [ "$DB_CONNECTION" = "pgsql" ] || [ "$DB_CONNECTION" = "mysql" ] && [ "$DB_HOST" ]; then
  echo "Waiting for database..."
  for i in {1..30}; do
    if nc -z "$DB_HOST" "$DB_PORT" 2>/dev/null; then
      break
    fi
    echo "DB not ready, waiting ($i/30)..."
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

# Clear caches first to avoid empty cache clear errors on Render
php artisan config:clear --quiet || true
php artisan route:clear --quiet || true
php artisan view:clear --quiet || true

# Cache configs (use env)
php artisan config:cache --quiet
php artisan route:cache --quiet
php artisan view:cache --quiet

# Start Apache
exec apache2-foreground
