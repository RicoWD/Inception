# USER_DOC

## Services provided
- `NGINX`: on port 443.
- `WordPress`: website (with PHP-FPM).
- `MariaDB`: database for WordPress.

## Start and stop the project
- `make` start everything
- `make start` start existing containers 
- `make stop` stop containers
- `make down` stop and remove containers

## Access the website and admin panel
1. Add your domain to /etc/hosts (example):
127.0.0.1 erpascua.42.fr
2. Open the website:
https://erpascua.42.fr
3. Open the admin dashboard:
https://erpascua.42.fr/wp-admin

## Locate and manage credentials
- Located at `srcs/.env`.
- `.env` not commited, need to be added separetly

## Check services health
- `make status` container status 
- `make logs` logs 
- `docker compose -f srcs/docker-compose.yml ps`

Expected containers:
- `mariadb`
- `wordpress`
- `nginx`
