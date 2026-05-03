#!/bin/sh

set -e

FLAG="/var/lib/mysql/.initialized"
DB_DIR="/var/lib/mysql/${MYSQL_DATABASE}"

rm -f /var/run/mysqld/mysqld.pid
rm -f /var/run/mysqld/mysqld.sock
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -f "$FLAG" ] || [ ! -d "$DB_DIR" ]; then
    echo "Initializing MariaDB"

    service mariadb start

    until mysqladmin ping --silent >/dev/null 2>&1; do
        echo "Waiting for MariaDB"
        sleep 2
    done

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    touch "$FLAG"
    echo "MariaDB initialized"
else
    echo "MariaDB already initialized"
fi

exec mysqld_safe --bind-address=0.0.0.0
