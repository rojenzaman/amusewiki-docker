#!/bin/bash

# set variable
INITIAL_DOMAIN_ID="1"
INITIAL_DOMAIN="$(sqlite3 "${AMW_SQLITE_PATH}" "SELECT canonical FROM site WHERE rowid = ${INITIAL_DOMAIN_ID};")"
if [[ ${CONTAINER_IS_IN_PWD} == true ]]; then
	PWD_PROXY_HOST=$(curl -s https://labs.play-with-docker.com/sessions/${SESSION_ID} | jq -r .instances[].proxy_host | head -1)
	POST_DOMAIN=${PWD_PROXY_HOST}-${PWD_PORT}.direct.${PWD_HOST_FQDN}
fi

# check variable and status
# terminate if domain is not set
if [ -z "${POST_DOMAIN}" ]; then
	exit 0
else
	# terminate if domain already exist
	if sqlite3 "${AMW_SQLITE_PATH}" "SELECT canonical FROM site;" | grep -q "${POST_DOMAIN}"; then
		exit 0
	fi
fi

# update domain for nginx
sudo chown -R amusewiki:amusewiki /etc/nginx/sites-enabled
sed "s/${INITIAL_DOMAIN}/${POST_DOMAIN}/g" /etc/nginx/sites-enabled/${NGX_PREFIX} > /tmp/${NGX_PREFIX}
cp /tmp/${NGX_PREFIX} /etc/nginx/sites-enabled || exit 1
sudo chown -R root:root /etc/nginx/sites-enabled

# update domain for database
sqlite3 "${AMW_SQLITE_PATH}" "update site SET canonical = '${POST_DOMAIN}' WHERE canonical = '${INITIAL_DOMAIN}';"
