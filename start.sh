#!/usr/bin/env sh
php artisan install --db-host="$SED_DB_HOST" --db-name="$SED_DB_DATABASE" --db-username="$SED_DB_USERNAME" --db-password="$SED_DB_PASSWORD" --admin-email="admin@company.com" --admin-password="123456" &
wait

nginx -g 'daemon off;' &
php-fpm --allow-to-run-as-root &
wait
