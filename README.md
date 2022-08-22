[![](https://img.shields.io/docker/image-size/rojen/amusewiki/latest)](https://hub.docker.com/r/rojen/amusewiki) [![rojen/amusewiki:package](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml) [![rojen/amusewiki:git](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/git.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/git.yml)  [![](https://img.shields.io/docker/pulls/rojen/amusewiki)](https://hub.docker.com/r/rojen/amusewiki)

<!--
https://badgen.net/docker/layers/rojen/amusewiki/latest/amd64?icon=docker&label=layers
-->

### Be careful!

This repo assumes you don't want to use non-sqlite databases.

### How to use?

Clone this repo:

```bash
git clone https://github.com/rojenzaman/amusewiki-docker
```

To use container with official packages, go to `package.amusewiki.org` directory:

```bash
cd amusewiki-docker/packages.amusewiki.org
```

To use container with amusewiki git source and texlive-base, go to `github.com` directory:

```bash
cd amusewiki-docker/github.com
```

To use container with amusewiki git source and texlive-full, go to `texlive-full` directory:

```bash
cd amusewiki-docker/texlive-full
```

Create sqlite database and repo files for the amusewiki docker-compose stack (if you have please replace with them):

```bash
make setup-example-stack
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
