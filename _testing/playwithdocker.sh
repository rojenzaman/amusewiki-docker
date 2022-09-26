#!/bin/sh
PWD_DOMAIN="ip$(ip a s eth1 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2 | sed 's/\./\-/g')-${SESSION_ID}-443.direct.${PWD_HOST_FQDN}"
docker run -d -e "POST_DOMAIN=${PWD_DOMAIN}" --network host --name amusewiki_pwd rojen/amusewiki:package
echo "https://${PWD_DOMAIN}"
