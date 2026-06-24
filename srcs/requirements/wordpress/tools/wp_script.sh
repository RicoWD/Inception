#!/bin/sh

set -e

WP_PATH="/var/www/html/wordpress"
FLAG="$WP_PATH/.flag"
PHP_CONF="/etc/php/8.2/fpm/pool.d/www.conf"

BACKUP_DIR="/backup"
BACKUP_SQL="$BACKUP_DIR/wordpress.sql"
BACKUP_CONTENT="$BACKUP_DIR/wp-content.tar.gz"

until mysqladmin ping -h mariadb --silent; do
    echo "Waiting for MariaDB..."
    sleep 1
done

if [ ! -f "$WP_PATH/wp-config.php" ] || [ ! -f "$FLAG" ]; then
    wp core download --allow-root --path="$WP_PATH"

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root \
        --path="$WP_PATH" \
        --force

    if [ -f "$BACKUP_SQL" ]; then
        # Restore the captured site (DB + wp-content) instead of a fresh install.
        echo "Backup found: restoring captured WordPress site"
        wp db import "$BACKUP_SQL" --allow-root --path="$WP_PATH"

        if [ -f "$BACKUP_CONTENT" ]; then
            tar xzf "$BACKUP_CONTENT" -C "$WP_PATH"
        fi

        # Normalize URLs in case the captured domain differs from the current one.
        OLD_DOMAIN="$(wp option get siteurl --allow-root --path="$WP_PATH" | sed -E 's#^https?://##; s#/.*$##')"
        if [ -n "$OLD_DOMAIN" ] && [ "$OLD_DOMAIN" != "$DOMAIN_NAME" ]; then
            echo "Rewriting URLs: $OLD_DOMAIN -> $DOMAIN_NAME"
            wp search-replace "$OLD_DOMAIN" "$DOMAIN_NAME" --allow-root --path="$WP_PATH" --skip-columns=guid
        fi
    else
        # No backup: fresh install from the .env values (default project flow).
        echo "No backup found: fresh WordPress install"
        wp core install \
            --url="$DOMAIN_NAME" \
            --title="$SITE_TITLE" \
            --admin_user="$ADMIN_USER" \
            --admin_password="$ADMIN_PASSWORD" \
            --admin_email="$ADMIN_EMAIL" \
            --allow-root \
            --path="$WP_PATH"

        wp user create "$USER_LOGIN" "$USER_EMAIL" \
            --role=author \
            --user_pass="$USER_PASS" \
            --allow-root \
            --path="$WP_PATH"
    fi

    # Configure Redis object cache if available
    # set constants in wp-config.php
    wp config set WP_REDIS_HOST redis --allow-root --path="$WP_PATH" || true
    wp config set WP_REDIS_PORT 6379 --raw --allow-root --path="$WP_PATH" || true

    # Install and activate Redis cache plugin (best-effort)
    wp plugin install redis-cache --activate --allow-root --path="$WP_PATH" || true
    wp redis enable --allow-root --path="$WP_PATH" || true

    chown -R www-data:www-data "$WP_PATH"
    touch "$FLAG"
fi

mkdir -p /run/php
chown www-data:www-data /run/php

sed -i 's|^listen =.*|listen = 0.0.0.0:9000|' "$PHP_CONF"

echo "Launch PHP-FPM 8.2"
exec /usr/sbin/php-fpm8.2 -F
