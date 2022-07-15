OCI = docker
TAG = git
BUILD_ARG = 

default: help
.DEFAULT_GOAL := default

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
	cat amusewiki/db/details.txt

help:
	@lib/makehelp.sh
