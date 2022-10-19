CONFIG = lib/make.config

default: help
.DEFAULT_GOAL := default

include $(CONFIG)

clean:
	rm -rf amusewiki
	rm -rf *.log
	mkdir -p amusewiki/repo amusewiki/staging amusewiki/db amusewiki/thumbnails amusewiki/nginx
	touch amusewiki/repo/.gitkeep amusewiki/staging/.gitkeep amusewiki/db/.gitkeep amusewiki/thumbnails/.gitkeep amusewiki/nginx/.gitkeep

clean-all:
	make clean
	rm -rf lib/containerless-backup
	rm -rf lib/amusewiki.tar

clean-rootless-podman:
	make clean
	sed -i 's/OCI = podman/OCI = docker/g' lib/make.config

build:
	$(OCI) build -t rojen/amusewiki:$(TAG) $(BUILD_ARGS) -f Dockerfile .

backup:
	tar -cvf lib/amusewiki.tar amusewiki/

backup-exclude-uploads:
	tar --exclude="amusewiki/repo/*/uploads" -cvf lib/amusewiki.tar amusewiki/

backup-external:
	mkdir -p lib/containerless-backup/amusewiki/db
	mkdir -p lib/containerless-backup/amusewiki/nginx
	rsync $(AMUSEWIKI_RSYNC_ARG) -radhzv --delete $(AMUSEWIKI_HOST):$(AMUSEWIKI_HOST_DB) lib/containerless-backup/amusewiki/db/amusewiki
	rsync $(AMUSEWIKI_RSYNC_ARG) -radhzv --delete $(AMUSEWIKI_HOST):$(AMUSEWIKI_HOST_DIR)/repo lib/containerless-backup/amusewiki/
	rsync $(AMUSEWIKI_RSYNC_ARG) -radhzv --delete $(AMUSEWIKI_HOST):$(AMUSEWIKI_HOST_DIR)/staging lib/containerless-backup/amusewiki/
	rsync $(AMUSEWIKI_RSYNC_ARG) -radhzv --delete $(AMUSEWIKI_HOST):$(AMUSEWIKI_HOST_DIR)/thumbnails lib/containerless-backup/amusewiki/
	rsync $(AMUSEWIKI_RSYNC_ARG) -radhzv --delete $(AMUSEWIKI_HOST):$(AMUSEWIKI_NGX_PATH) lib/containerless-backup/amusewiki/nginx/
	-$(POST_CONTAINERLESS_BACKUP)
	tar -cvf lib/amusewiki.tar -C lib/containerless-backup amusewiki/

exec:
	lib/exec.sh $(OCI) $(TAG) $(ENV_FILE)

help:
	@lib/makehelp.sh

restore:
	tar -xvf lib/amusewiki.tar

restore-with-clean:
	make clean
	make restore

rootless-podman:
	sed -i "s/80/$(PODMAN_HTTP_PORT)/g" amusewiki/nginx/amusewiki*
	sed -i "s/443/$(PODMAN_HTTPS_PORT)/g" amusewiki/nginx/amusewiki*
	sed -i 's/OCI = docker/OCI = podman/g' lib/make.config
	-$(POST_SETUP)

setup-example-stack:
	make clean
	wget -O lib/amusewiki.tar $(REMOTE_TAR)
	make restore
	-$(POST_SETUP)
	cat amusewiki/db/details.txt

setup-example-rootless-podman-stack:
	make clean
	wget -O lib/amusewiki.tar $(REMOTE_TAR)
	make restore
	sed -i "s/80/$(PODMAN_HTTP_PORT)/g" amusewiki/nginx/amusewiki*
	sed -i "s/443/$(PODMAN_HTTPS_PORT)/g" amusewiki/nginx/amusewiki*
	sed -i "s%http://amusewiki.localdomain%http://amusewiki.localdomain:8080%g" amusewiki/db/details.txt
	sed -i 's/OCI = docker/OCI = podman/g' lib/make.config
	-$(POST_SETUP)
	cat amusewiki/db/details.txt
	@printf "\n\nplease set up a reserve proxy to $(PODMAN_HTTP_PORT) and $(PODMAN_HTTPS_PORT) port:\n\n"
	@cat lib/example_proxy

shell:
	$(OCI)-compose exec app bash
