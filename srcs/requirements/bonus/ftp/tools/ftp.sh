#!/bin/sh

set -e

: "${FTP_PORT:=21}"
: "${FTP_PASV_MIN:=21100}"
: "${FTP_PASV_MAX:=21110}"

envsubst '${FTP_PORT} ${FTP_PASV_MIN} ${FTP_PASV_MAX}' \
    < /etc/vsftpd.conf.template \
    > /etc/vsftpd.conf

mkdir -p /var/run/vsftpd/empty

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -d /var/www/html -s /bin/bash "$FTP_USER"
fi

echo "${FTP_USER}:${FTP_PASS}" | chpasswd

chown -R "$FTP_USER":"$FTP_USER" /var/www/html

echo "Launch vsftpd"
exec /usr/sbin/vsftpd /etc/vsftpd.conf
