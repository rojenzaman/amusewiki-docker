#!/bin/bash
PWD_PORT=${1}; PORT_TYPE=${2:-http}; OCI=${3:-docker}; ID=${RANDOM}; if [[ "$#" -lt 1 ]]; then echo "Usage: ${BASH_SOURCE[0]} <port> [http|https] [docker|podman]"; exit 1; fi
case ${PORT_TYPE} in https) BIND_PORT=443;; *) BIND_PORT=80;; esac

# main
echo "deploying amusewiki_pwd_${ID}"
${OCI} run -d -p ${PWD_PORT}:${BIND_PORT}  \
 -e PWD_HOST_FQDN=labs.play-with-docker.com \
 -e SESSION_ID=${SESSION_ID} \
 -e CONTAINER_IS_IN_PWD=true \
 -e PWD_PORT=${PWD_PORT} \
 -e AMW_WORKERS=5 \
--name amusewiki_pwd_${ID} rojen/amusewiki:package && {
	echo "attaching to amusewiki_pwd_${ID}"
	${OCI} exec -it amusewiki_pwd_${ID} bash
}
