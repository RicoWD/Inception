#!/bin/sh

set -e

mkdir -p /data

cd /opt/portainer

: "${PORTAINER_PORT:=9000}"

exec ./portainer --bind="0.0.0.0:${PORTAINER_PORT}" --data /data
