OCI = docker
TAG = repo

default: help
.DEFAULT_GOAL := default

clean:
	rm -rf repo db thumbnails
	mkdir repo db thumbnails
	touch repo/.gitkeep db/.gitkeep thumbnails/.gitkeep

build:
	$(OCI) build -t rojen/amusewiki:$(TAG) -f Dockerfile.$(TAG) .

exec:
	.lib/exec.sh $(OCI) $(TAG)

backup:
	tar -cvf .lib/amusewiki.tar repo/ db/ thumbnails/

restore:
	make clean
	tar -xvf .lib/amusewiki.tar

shell:
	$(OCI)-compose exec app bash

setup-example-stack:
	make clean
	wget -O .lib/amusewiki.tar https://ftp.rojenz.de/amusewiki.tar
	make restore
	cat db/details.txt

help:
	@.lib/makehelp.sh
