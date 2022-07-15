CONFIG = lib/make.config

default: help
.DEFAULT_GOAL := default

include $(CONFIG)

clean:
	rm -rf amusewiki
	mkdir -p amusewiki/repo amusewiki/db amusewiki/thumbnails amusewiki/nginx
	touch amusewiki/repo/.gitkeep amusewiki/db/.gitkeep amusewiki/thumbnails/.gitkeep amusewiki/nginx/.gitkeep

build:
	$(OCI) build -t rojen/amusewiki:$(TAG) $(BUILD_ARG) -f Dockerfile.$(TAG) .

exec:
	lib/exec.sh $(OCI) $(TAG)

backup:
	tar -cvf lib/amusewiki.tar amusewiki/

restore:
	make clean
	tar -xvf lib/amusewiki.tar

shell:
	$(OCI)-compose exec app bash

setup-example-stack:
	make clean
	wget -O lib/amusewiki.tar https://ftp.rojenz.de/amusewiki.tar
	make restore
	$(POST_SETUP)
	cat amusewiki/db/details.txt

rootless-podman:
	make clean
	wget -O lib/amusewiki.tar https://ftp.rojenz.de/amusewiki.tar
	make restore
	sed -i "s/80/$(PODMAN_HTTP_PORT)/g" amusewiki/nginx/amusewikidebian
	sed -i "s/443/$(PODMAN_HTTPS_PORT)/g" amusewiki/nginx/amusewikidebian
	sed -i "s%http://amusewiki.localdomain%http://amusewiki.localdomain:8080%g" amusewiki/db/details.txt
	sed -i 's/OCI = docker/OCI = podman/g' lib/make.config
	cat amusewiki/db/details.txt
	@printf "\n\nplease set up a reserve proxy to $(PODMAN_HTTP_PORT) and $(PODMAN_HTTPS_PORT) port:\n\n"
	@cat lib/example_proxy

uninstall-rootless-podman:
	make clean
	sed -i 's/OCI = podman/OCI = docker/g' lib/make.config

help:
	@lib/makehelp.sh
