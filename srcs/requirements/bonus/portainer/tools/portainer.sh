#!/bin/sh

set -e

mkdir -p /data

cd /opt/portainer

exec ./portainer --bind=0.0.0.0:9000 --data /data
