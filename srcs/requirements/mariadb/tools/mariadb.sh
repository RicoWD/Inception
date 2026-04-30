# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    mariadb.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: erpascua <erpascua@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/30 16:16:01 by erpascua          #+#    #+#              #
#    Updated: 2026/04/30 16:16:04 by erpascua         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

FLAG="/var/lib/mysql/.flag"
DB_DIR="/var/lib/mysql/wordpress"

rm -f /var/run/mysqld/mysqld.pid
rm -f /var/run/mysqld/mysqld.sock
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -f "$FLAG" ] || [ ! -d "$DB_DIR" ] ; then

    echo "Init MariaDB"

    service mariadb start

    until mysqladmin ping >/dev/null 2>&1; do
        echo "Waiting MariaDB"
        sleep 2
    done

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    touch "$FLAG"
    echo "MariaDB installed"
else
    echo "MariaDB already installed"
fi

exec mysqld_safe --bind-address=0.0.0.0