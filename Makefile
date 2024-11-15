





COLOR_RESET := \033[0m
COLOR_CXX := \033[1;34m
COLOR_GREEN := \033[1;32m
COLOR_ERROR := \033[1;31m
COLOR_CLEAN := \033[1;36m
COLOR_PRUP := \033[1;35m
COLOR_MSG := \033[1;35m
COLOR_RED := \033[1;31m

PROGRAM_NAME := inception
DOCKER-COMPOSE 	:= ./srcs/docker-compose.yml
ENV_FILE := ./srcs/.env
VOLUMES_DIR := /home/onault/data

MESSAGE := "$(COLOR_MSG)╭────────────────────────────────╮\n│🌟$(PROGRAM_NAME) Built Successfully🌟│\n╰────────────────────────────────╯$(COLOR_RESET)"

all: build

build: setup
	@echo  "$(COLOR_GREEN)start to build...$(COLOR_RESET)"
	@docker compose -f $(DOCKER-COMPOSE) --env-file $(ENV_FILE) up -d --build
	@echo  "$(COLOR_OK)Build succeeded!$(COLOR_RESET)"
	@echo $(MESSAGE)
start:
	docker compose -f $(DOCKER-COMPOSE) start
	@echo $(MESSAGE)
stop:
	@echo  "$(COLOR_RED)stopping the containers...$(COLOR_RESET)"
	docker compose -f $(DOCKER-COMPOSE) stop
	@echo  "$(COLOR_RED)finished!$(COLOR_RESET)"


down:
	@echo  "$(COLOR_RED)taking everything down!$(COLOR_RESET)"
	docker compose -f $(DOCKER-COMPOSE) down 
	@echo  "$(COLOR_RED)finished!$(COLOR_RESET)"

ps:
	docker ps

clean: stop
	@echo  "$(COLOR_CLEAN)Cleaning object files and target...$(COLOR_RESET)"
	docker compose -f $(DOCKER-COMPOSE) down

fclean: clean
	@echo  "$(COLOR_CLEAN)Cleaning object files and target...$(COLOR_RESET)"
	docker rmi -f $$(docker images -qa) >> /dev/null

prune: down
	@echo  "$(COLOR_CLEAN)Cleaning object files and target...$(COLOR_RESET)"
	docker image prune -a
	sudo rm -rf $(VOLUMES_DIR)
	docker compose -f $(DOCKER-COMPOSE) down --remove-orphans
	docker compose -f $(DOCKER-COMPOSE) down --volumes

re: fclean all
	

images:
	@echo  "$(COLOR_GREEN)every images$(COLOR_RESET)"
	docker images -qa

network:
	@echo  "$(COLOR_GREEN)every network$(COLOR_RESET)"
	docker network ls

volume:
	@echo  "$(COLOR_GREEN)every volume$(COLOR_RESET)"
	docker volume ls

logs:
	@echo  "$(COLOR_GREEN)these are the logs$(COLOR_RESET)"
	docker logs -t -f $$(docker compose -f $(DOCKER-COMPOSE) ps -q nginx)

setup:
	@echo  "$(COLOR_CXX)Creating the volumes folders...$(COLOR_RESET)"
	mkdir -p $(VOLUMES_DIR)/wordpress
	mkdir -p $(VOLUMES_DIR)/mariadb

help:
	@echo  "$(COLOR_PRUP)make the project:$(COLOR_RESET)"
	@echo  "  $(COLOR_CXX)make$(COLOR_RESET)         - Build the project"
	@echo  "  $(COLOR_CXX)make build$(COLOR_RESET)   - Build the project and create the folders"
	@echo  "  $(COLOR_CXX)make re$(COLOR_RESET)      - Rebuild the project"
	@echo  "  $(COLOR_CXX)make start$(COLOR_RESET)   - Start if stop"
	@echo  "$(COLOR_PRUP)make helpers:$(COLOR_RESET)"
	@echo  "  $(COLOR_GREEN)make logs$(COLOR_RESET)    - Show the logs"
	@echo  "  $(COLOR_GREEN)make volume$(COLOR_RESET)  - Show all volumes"
	@echo  "  $(COLOR_GREEN)make images$(COLOR_RESET)  - Show all images"
	@echo  "  $(COLOR_GREEN)make network$(COLOR_RESET) - Show all networks"
	@echo  "  $(COLOR_GREEN)make ps$(COLOR_RESET)      - Show all containers"
	@echo  "$(COLOR_PRUP)make cleaning:$(COLOR_RESET)"
	@echo  "  $(COLOR_CXX)make clean$(COLOR_RESET)   - Clean object files"
	@echo  "  $(COLOR_CXX)make fclean$(COLOR_RESET)  - Full clean (includes target)"
	@echo  "  $(COLOR_CXX)make prune$(COLOR_RESET)   - Clean object files"
	@echo  "  $(COLOR_CXX)make down$(COLOR_RESET)    - stop containers and delete it"
	@echo  "  $(COLOR_CXX)make stop$(COLOR_RESET)    - Stop containers"
	@echo  "$(COLOR_PRUP)make others:$(COLOR_RESET)"
	@echo  "  $(COLOR_GREEN)make help$(COLOR_RESET)    - Show this help message"
	@echo  "  $(COLOR_GREEN)make setup$(COLOR_RESET)   - Create the volumes folder"




.PHONY: all setup build start stop down ps clean fclean re images network volume logs help