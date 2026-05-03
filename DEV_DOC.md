# DEV_DOC

## Environment setup from scratch
### Prerequisites
- Linux VM
- Docker Engine
- Docker Compose plugin
- make

### Required local configuration
1. Create host data folders:
- /home/<login>/data/mariadb
- /home/<login>/data/wordpress
2. Update srcs/.env with your login and domain.
3. Add your domain to /etc/hosts.

## Build and launch
- Build and launch all services: make
- Rebuild explicitly: make up
- Full cleanup and rebuild: make re

## Container and volume management
- Check state: make status
- Follow logs: make logs
- Stop: make stop
- Start stopped containers: make start
- Tear down: make down
- Remove images, containers, volumes: make clean

## Data persistence
Persistent data is stored through named Docker volumes:
- mariadb_data -> /home/<login>/data/mariadb
- wordpress_data -> /home/<login>/data/wordpress

Verify:
- docker volume ls
- docker volume inspect mariadb_data
- docker volume inspect wordpress_data

## Project layout overview
- srcs/docker-compose.yml: orchestration
- srcs/.env: environment variables
- srcs/requirements/nginx: nginx image, TLS config, startup script
- srcs/requirements/wordpress: wordpress + php-fpm image and bootstrap script
- srcs/requirements/mariadb: mariadb image and initialization script
