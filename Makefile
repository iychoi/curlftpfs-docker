DOCKER_COMPOSE ?= docker-compose -f containers/docker-compose.yml

.PHONY: all build clean up

all: up

build:
	$(DOCKER_COMPOSE) build
	@docker tag sdmbench syndicatestorage/sdmbench

up: build
	-$(DOCKER_COMPOSE) run sdmbench

push: build
	@docker push syndicatestorage/sdmbench

clean:
	-$(DOCKER_COMPOSE) stop
	-$(DOCKER_COMPOSE) rm --force --all
