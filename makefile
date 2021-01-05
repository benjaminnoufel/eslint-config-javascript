.PHONY: npmjs token install build clean publish publish-npmjs

DOCKER_COMPOSE_RUN_OPTIONS=--rm
ifeq (${CI},true)
    DOCKER_COMPOSE_RUN_OPTIONS=--rm --user root -T
endif

PACKAGE_VERSION=$(shell cat package.json | grep -i version | sed -e "s/ //g" | cut -c 12- | sed -e "s/\",//g")

npmjs:
	@docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) bash -c 'echo "//registry.npmjs.org/:_authToken=$$NPMJS_AUTH_TOKEN" >> .npmrc'
	@docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) bash -c 'echo "@benjaminnoufel:registry=https://registry.npmjs.org/" >> .npmrc'

token:
	@docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) bash -c 'echo "//npm.pkg.github.com/:_authToken=$$NPM_AUTH_TOKEN" >> .npmrc'
	@docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) bash -c 'echo "@benjaminnoufel:registry=https://npm.pkg.github.com/" >> .npmrc'

install:
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) yarn install

build:
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) yarn build

clean:
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) bash -c 'for file in $(shell cat .gitignore); do if [ "/.env" != "$$file" -a "/.idea" != "$$file" ]; then rm -rf .$$file; fi; done'

publish:
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) yarn publish --access public --registry https://npm.pkg.github.com/ --new-version $(PACKAGE_VERSION) --non-interactive

publish-npmjs:
	docker-compose run $(DOCKER_COMPOSE_RUN_OPTIONS) yarn publish --access public --registry https://registry.npmjs.org/ --new-version $(PACKAGE_VERSION) --non-interactive


