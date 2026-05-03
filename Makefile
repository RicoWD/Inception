NAME		= Inception
DOCKER_COMPOSE	= docker compose -f ./srcs/docker-compose.yml
PATH_DATA	= /home/$(USER)/data

all: up

setup:
	@mkdir -p $(PATH_DATA)/mariadb
	@mkdir -p $(PATH_DATA)/wordpress

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

status:
	@$(DOCKER_COMPOSE) ps

logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: all setup up down stop start clean fclean re status logs
