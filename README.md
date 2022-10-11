## Amusewiki Docker

[![](https://img.shields.io/docker/image-size/rojen/amusewiki/latest)](https://hub.docker.com/r/rojen/amusewiki) [![rojen/amusewiki:package](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/package.yml) [![rojen/amusewiki:git](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-base.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-base.yml) [![rojen/amusewiki:texlive-full](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-full.yml/badge.svg)](https://github.com/rojenzaman/amusewiki-docker/actions/workflows/texlive-full.yml) [![](https://img.shields.io/docker/pulls/rojen/amusewiki)](https://hub.docker.com/r/rojen/amusewiki)

<!--
https://badgen.net/docker/layers/rojen/amusewiki/latest/amd64?icon=docker&label=layers
-->

### Tags

 - [`package, latest, package-2.551, package-2.560`](https://github.com/rojenzaman/amusewiki-docker/blob/master/package/Dockerfile)
 - [`texlive-base`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-base/Dockerfile)
 - [`texlive-full`](https://github.com/rojenzaman/amusewiki-docker/blob/master/texlive-full/Dockerfile)

### Be careful!

This repo use SQLite as a database. Currently MySQL and PostgreSQL are not supported. See: [TODO](https://github.com/rojenzaman/amusewiki-docker/blob/master/TODO.md)

### Quickly deploy a demo on [Play With Docker](https://labs.play-with-docker.com/?stack=https://gist.github.com/rojenzaman/c6bd978a3dca9a90661baba96186c46d/raw/05683239655b2f46d462c117f9ed8c00cc34246c/stack.yml&stack_name=amusewiki)

[![Try in PWD](https://raw.githubusercontent.com/play-with-docker/stacks/master/assets/images/button.png)](https://labs.play-with-docker.com/?stack=https://gist.github.com/rojenzaman/c6bd978a3dca9a90661baba96186c46d/raw/05683239655b2f46d462c117f9ed8c00cc34246c/stack.yml&stack_name=amusewiki)

Click the button above then click **start**, wait for it to deploy. Then click **80**.

 - The default username is: `amusewiki`
 - The default password is: `changeme`

### How to use?

Read the usage notes: [amusewiki-docker/wiki](https://github.com/rojenzaman/amusewiki-docker/wiki)

### Related Projects

 - [coop-cloud/amusewiki](https://git.coopcloud.tech/coop-cloud/amusewiki): Run amusewiki on [Co-op Cloud](https://docs.coopcloud.tech) with HTTPS Traefik.
