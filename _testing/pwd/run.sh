#!/bin/bash
PWD_PORT=${1}; OCI=${2:-docker}; ID=${RANDOM}; if [[ "$#" -lt 1 ]]; then echo "Usage: ${BASH_SOURCE[0]} <port> [docker|podman]"; exit 1; fi
if ! [[ "${PWD_PORT}" =~ ^(80|443)$ ]]; then echo "port must be 80 or 443"; exit 1; fi

# main
echo "deploying amusewiki_pwd_${ID}"
${OCI} run -d --network host \
 -e PWD_HOST_FQDN=${PWD_HOST_FQDN} \
 -e SESSION_ID=${SESSION_ID} \
 -e CONTAINER_IS_IN_PWD=true \
 -e PWD_PORT=${PWD_PORT} \
 -e AMW_WORKERS=5 \
--name amusewiki_pwd_${ID} rojen/amusewiki:package && {
	echo "attaching to amusewiki_pwd_${ID}"
	${OCI} exec -it amusewiki_pwd_${ID} bash
}
