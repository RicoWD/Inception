NAME		= Inception
DOCKER_COMPOSE	= docker compose -f ./srcs/docker-compose.yml
LOGIN		:= $(shell grep -E '^LOGIN=' ./srcs/.env | cut -d '=' -f2)
PATH_DATA	= /home/$(LOGIN)/data

all: up

setup:
	@mkdir -p $(PATH_DATA)/mariadb
	@mkdir -p $(PATH_DATA)/wordpress
	@mkdir -p $(PATH_DATA)/redis
	@mkdir -p $(PATH_DATA)/portainer

up:setup
	@$(DOCKER_COMPOSE) up -d --build

down:
	@$(DOCKER_COMPOSE) down

stop:
	@$(DOCKER_COMPOSE) stop

start:
	@$(DOCKER_COMPOSE) start

clean:
	@$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans

fclean: clean
	@docker system prune -af

re: fclean all

BACKUP_DIR	= ./srcs/requirements/wordpress/backup

backup:
	@echo "Exporting WordPress database..."
	@docker exec wordpress wp db export /tmp/wordpress.sql --allow-root --path=/var/www/html/wordpress
	@docker cp wordpress:/tmp/wordpress.sql $(BACKUP_DIR)/wordpress.sql
	@echo "Archiving wp-content (themes, plugins, uploads)..."
	@docker exec wordpress tar czf /tmp/wp-content.tar.gz -C /var/www/html/wordpress wp-content
	@docker cp wordpress:/tmp/wp-content.tar.gz $(BACKUP_DIR)/wp-content.tar.gz
	@echo "Backup written to $(BACKUP_DIR) -> commit it to persist your site across rebuilds."

restore:
	@test -f $(BACKUP_DIR)/wordpress.sql || { echo "No backup found in $(BACKUP_DIR). Run 'make backup' first."; exit 1; }
	@echo "Importing WordPress database..."
	@docker cp $(BACKUP_DIR)/wordpress.sql wordpress:/tmp/wordpress.sql
	@docker exec wordpress wp db import /tmp/wordpress.sql --allow-root --path=/var/www/html/wordpress
	@if [ -f $(BACKUP_DIR)/wp-content.tar.gz ]; then \
		echo "Restoring wp-content (themes, plugins, uploads)..."; \
		docker cp $(BACKUP_DIR)/wp-content.tar.gz wordpress:/tmp/wp-content.tar.gz; \
		docker exec wordpress tar xzf /tmp/wp-content.tar.gz -C /var/www/html/wordpress; \
		docker exec wordpress chown -R www-data:www-data /var/www/html/wordpress/wp-content; \
	fi
	@echo "Restore complete."

status:
	@$(DOCKER_COMPOSE) ps

logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: all setup up down stop start clean fclean re status logs backup restore
