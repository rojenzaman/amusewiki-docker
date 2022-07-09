#!/bin/bash
OCI="${1}"
TAG="${2}"

if [[ ! "$(${OCI} ps -a | grep "amusewiki_${TAG}")" ]]; then
        ${OCI} run -d --network host --name amusewiki_${TAG} rojen/amusewiki:${TAG}
fi

if [[ ! "$(${OCI} ps| grep "amusewiki_${TAG}")" ]]; then
        ${OCI} start amusewiki_${TAG}
fi

${OCI} exec -it amusewiki_${TAG} /bin/bash
