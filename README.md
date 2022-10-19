## Amusewiki Docker

[![](https://img.shields.io/docker/image-size/rojen/amusewiki/latest)](https://hub.docker.com/r/rojen/amusewiki) [![](https://img.shields.io/docker/image-size/rojen/amusewiki/texlive-minimal)](https://hub.docker.com/r/rojen/amusewiki) [![rojen/amusewiki:package](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml) [![rojen/amusewiki:texlive-minimal](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-minimal.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-minimal.yml) [![rojen/amusewiki:texlive-base](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-base.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-base.yml) [![rojen/amusewiki:texlive-full](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-full.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-full.yml) [![](https://img.shields.io/docker/pulls/rojen/amusewiki)](https://hub.docker.com/r/rojen/amusewiki)

<!--
https://badgen.net/docker/layers/rojen/amusewiki/latest/amd64?icon=docker&label=layers
-->

### Quickly deploy a demo on [Play With Docker](_testing/pwd)

[![Try in PWD](https://raw.githubusercontent.com/play-with-docker/stacks/master/assets/images/button.png)](https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/rojenzaman/amusewiki-docker/master/_testing/pwd/package.yml&stack_name=amusewiki)

Click the button above then click **start**, wait for it to deploy. Then click **80**.

 - The default username is: `amusewiki`
 - The default password is: `changeme`

### Tags

 - [`package, latest, package-2.551, package-2.560`](https://github.com/rojenzaman/amusewiki-docker/blob/master/package/Dockerfile)
 - [`texlive-minimal`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-minimal/Dockerfile)
 - [`texlive-base`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-base/Dockerfile)
 - [`texlive-full`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-full/Dockerfile)

### Environment Variables

| Name | Required | Description
|---|---|---
| `POST_DOMAIN` | No | Change initial domain
| `CONTAINER_IS_BEHIND_HTTPS_TRAEFIK` | No | Setting this to `true` will enable HTTPS Traefik support
| `AMW_WORKERS` | No | Specify number of process set by script/init-fcgi.pl
| `AMW_NPROC` | No | Specify number of perl-fcgi process
| `CHANGE_PASSWORD_BEFORE_RUN` | No | Setting this to `true` will enable password changing
| `AMW_USERNAME` | No | Set username
| `AMW_PASSWORD` | No | Set password
| `HOST_SSH_PUBLIC_KEY` | No | Authorize host ssh public key
| `GENERATE_NEW_SSH_KEY` | No | Setting thist to `true` will crate new ssh key
| `NGX_PREFIX` | No | `amusewikidebian` or `amusewiki`
| `AMUSEWIKI_SWITCH_BRANCH` | No | Switch to given branch before run (*texlive-minimal*, *texlive-base*, *texlive-full*)
| `CREATE_MISSING_STAGING_FILES` | No | Setting this to `true` will create missing staging files

### Volumes

 - `/var/lib/amusewiki/repo`  **git**
 - `/var/lib/amusewiki/thumbnails`  **thumb**
 - `/var/lib/amusewiki/staging` **staging**
 - Depending on the database path:
   - Mount as volume`/var/lib/dbconfig-common/sqlite3/amusewiki` **db** (*package*)
   - Mount as persistent volume: `/var/lib/amusewiki/sqlite.db` **db** and `/var/lib/amusewiki/dbic.yaml`  **db-conf** (*texlive-minimal*, *texlive-base*, *texlive-full*)
 - `/etc/nginx/sites-enabled` **web**

### Be careful!

This repo use SQLite as a database. Currently MySQL and PostgreSQL are not supported. See: [TODO](https://github.com/rojenzaman/amusewiki-docker/blob/master/TODO.md)

This image is production ready! Beleive it or not.

### How to use?

Read the usage notes and check the example **docker-compose.yml** files: [amusewiki-docker/wiki](https://github.com/rojenzaman/amusewiki-docker/wiki)

### Related Projects

 - [coop-cloud/amusewiki](https://git.coopcloud.tech/coop-cloud/amusewiki): Run amusewiki on [Co-op Cloud](https://docs.coopcloud.tech) with HTTPS Traefik.
