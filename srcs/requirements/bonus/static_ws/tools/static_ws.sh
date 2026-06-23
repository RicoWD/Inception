#!/bin/sh
set -e

: "${STATIC_WS_PORT:=8081}"

envsubst '${STATIC_WS_PORT}' \
	< /etc/nginx/templates/default.conf.template \
	> /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
