#!/bin/sh

set -e

if [ -f /etc/redis/redis.conf ]; then
  sed -i "s/^bind .*/bind 0.0.0.0/" /etc/redis/redis.conf || true
  sed -i "s/^protected-mode yes/protected-mode no/" /etc/redis/redis.conf || true
fi

exec redis-server /etc/redis/redis.conf
