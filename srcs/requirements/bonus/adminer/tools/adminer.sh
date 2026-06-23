#!/bin/sh

set -e

: "${ADMINER_PORT:=8080}"

exec php -S "0.0.0.0:${ADMINER_PORT}" -t /var/www/adminer
