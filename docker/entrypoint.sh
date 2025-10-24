#!/bin/sh

cd /var/www/app

echo ">>> Adjusting storage and cache permissions..."
chown -R www-data:www-data /var/www/app/storage /var/www/app/bootstrap/cache
chmod -R 775 /var/www/app/storage /var/www/app/bootstrap/cache

echo ">>> Caching configuration for production..."
php artisan config:cache
php artisan route:cache

echo ">>> Laravel is ready. Starting main services..."

exec "$@"