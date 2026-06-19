NAME		= Inception
DOCKER_COMPOSE	= docker compose -f ./srcs/docker-compose.yml
LOGIN		:= $(shell grep -E '^LOGIN=' ./srcs/.env | cut -d '=' -f2)
PATH_DATA	= /home/$(LOGIN)/data

all: up

setup:
	@mkdir -p $(PATH_DATA)/mariadb
	@mkdir -p $(PATH_DATA)/wordpress
	@mkdir -p $(PATH_DATA)/redis

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
