#!/bin/sh

set -e

mkdir -p /var/run/vsftpd/empty

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -d /var/www/html -s /bin/bash "$FTP_USER"
fi

echo "${FTP_USER}:${FTP_PASS}" | chpasswd

chown -R "$FTP_USER":"$FTP_USER" /var/www/html

echo "Launch vsftpd"
exec /usr/sbin/vsftpd /etc/vsftpd.conf
