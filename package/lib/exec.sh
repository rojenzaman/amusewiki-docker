#!/bin/bash
OCI="${1}"
TAG="${2}"
ENV_FILE="${3}"

if [[ ! "$(${OCI} ps -a | grep "amusewiki_${TAG}")" ]]; then
        ${OCI} run --env-file=${ENV_FILE} -d --network host --name amusewiki_${TAG} rojen/amusewiki:${TAG}
fi

if [[ ! "$(${OCI} ps| grep "amusewiki_${TAG}")" ]]; then
        ${OCI} start amusewiki_${TAG}
fi

${OCI} exec -it amusewiki_${TAG} /bin/bash
