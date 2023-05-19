#!/bin/bash

# set pre domain variable
PRE_DOMAIN_ID="1"
if [[ ${CHANGE_DOMAIN_BY_ID} == ?(-)+([0-9]) ]]; then
	if [[ $(sqlite3 "${AMW_SQLITE_PATH}" "SELECT EXISTS(SELECT canonical FROM site WHERE rowid = ${CHANGE_DOMAIN_BY_ID});") == 1 ]]; then
		PRE_DOMAIN_ID=${CHANGE_DOMAIN_BY_ID}
	fi
fi
PRE_DOMAIN="$(sqlite3 "${AMW_SQLITE_PATH}" "SELECT canonical FROM site WHERE rowid = ${PRE_DOMAIN_ID};")"

# check if container is in pwd
if [[ ${CONTAINER_IS_IN_PWD} == true ]]; then
	PWD_PROXY_HOST=$(curl -s https://labs.play-with-docker.com/sessions/${SESSION_ID} | jq -r .instances[].proxy_host | head -1)
	POST_DOMAIN=${PWD_PROXY_HOST}-${PWD_PORT}.direct.${PWD_HOST_FQDN}
fi

# check post domain variable and status
# terminate if post domain is not set
if [[ -z "${POST_DOMAIN}" ]]; then
	exit 0
else
	# terminate if domain already exist
	if [[ "${PRE_DOMAIN}" == "${POST_DOMAIN}" ]]; then
		exit 0
	fi
fi

# update domain for database
sqlite3 "${AMW_SQLITE_PATH}" "update site SET canonical = '${POST_DOMAIN}' WHERE rowid = '${PRE_DOMAIN_ID}';"

# update domain for nginx
sudo chown -R amusewiki:amusewiki /etc/nginx
if command -v carton; then
	carton exec ./script/amusewiki-generate-nginx-conf | grep 'nginx-amusewiki-' | grep -v 'reload' | bash
else
	(
		cd /var/lib/amusewiki
		amusewiki-generate-nginx-conf | grep 'nginx-amusewiki-' | grep -v 'reload' | bash
	)
fi
sudo chown -R root:root /etc/nginx
