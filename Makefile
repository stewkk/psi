PYTHON     = $(firstword $(shell which python3.9 python3.8 python3.7 python3))

# NOTE: use Makefile.local for customization
-include Makefile.local

.PHONY: all
all: docker

TARGETS = \
	run \
	clean
DOCKER_TARGETS = $(foreach target,$(TARGETS),docker-$(target))
.PHONY: $(TARGETS) $(DOCKER_TARGETS) docker docker-update

run:
	@python3 main.py

clean:

docker:
	@docker compose run --rm -it app bash

docker-update:
	@docker build --tag stewkk/refal-dev .
	@docker push stewkk/refal-dev
	@docker compose pull

$(DOCKER_TARGETS): docker-%:
	@docker compose run --service-ports --rm app $(MAKE) $*

.PHONY: docker-clean-data
docker-clean-data:
	@docker compose down -v
