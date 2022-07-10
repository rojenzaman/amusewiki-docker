### How to use?

Clone this repo:

```bash
git clone https://github.com/rojenzaman/amusewiki-docker
```

To use container with official packages, go to `package.amusewiki.org` directory:

```bash
cd amusewiki-docker/packages.amusewiki.org
```

To use container with amusewiki git source, go to `amusewiki-git` directory:

```bash
cd amusewiki-docker/amusewiki-git
```

Create sqlite database and repo files for the amusewiki docker-compose stack (if you have please replace with them):

```bash
make setup-example-stack
```

Then build and run:

```bash
docker-compose up -d --build
```
