## Amusewiki Docker

[![](https://img.shields.io/docker/image-size/rojen/amusewiki/latest)](https://hub.docker.com/r/rojen/amusewiki) [![rojen/amusewiki:package](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml) [![rojen/amusewiki:git](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-base.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-base.yml) [![rojen/amusewiki:texlive-full](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-full.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-full.yml) [![](https://img.shields.io/docker/pulls/rojen/amusewiki)](https://hub.docker.com/r/rojen/amusewiki)

<!--
https://badgen.net/docker/layers/rojen/amusewiki/latest/amd64?icon=docker&label=layers
-->

### Tags

 - [`package, latest, package-2.551`](https://github.com/rojenzaman/amusewiki-docker/blob/master/package/Dockerfile)
 - [`texlive-base`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-base/Dockerfile)
 - [`texlive-full`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-full/Dockerfile)

### Be careful!

This repo use SQLite as a database. Currently MySQL and PostgreSQL are not supported. See: [TODO](https://github.com/rojenzaman/amusewiki-docker/blob/master/TODO.md)

### How to use?

Clone this repo:

```bash
git clone https://github.com/rojenzaman/amusewiki-docker
```

To use container with official packages, go to `package.amusewiki.org` directory:

```bash
cd amusewiki-docker/package
```

To use container with amusewiki git source and texlive-base, go to `texlive-base` directory:

```bash
cd amusewiki-docker/texlive-base
```

To use container with amusewiki git source and texlive-full, go to `texlive-full` directory:

```bash
cd amusewiki-docker/texlive-full
```

Create sqlite database and repo files for the amusewiki docker-compose stack (if you have please replace with them):

```bash
make setup-example-stack
```

The default domain is [amusewiki.localdomain](http://amusewiki.localdomain). To change it, edit this line in `lib/container.env`:

```bash
#POST_DOMAIN=localhost
```

Then build/pull and run:

```bash
# to build and run
docker-compose up -d --build

# to pull and run
cp lib/testing.yml docker-compose.yml
docker-compose up -d
```

#### Rootless Podman

If you want to run under rootless podman, please execute the following instead of above:

```bash
make setup-example-rootless-podman-stack
```

```bash
# to build and run:
podman-compose up -d --build

# to pull and run:
cp lib/testing.yml docker-compose.yml
podman-compose up -d
```
