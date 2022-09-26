#!/bin/bash

# set database
# TODO: Support MySQL and PostgreSQL if they come out
if grep -q "dbconfig-common" /var/lib/amusewiki/dbic.yaml; then
	DB=/var/lib/dbconfig-common/sqlite3/amusewiki/amusewiki
else
	DB=/var/lib/amusewiki/sqlite.db
fi

# set variable
INITIAL_DOMAIN_ID="1"
INITIAL_DOMAIN="$(sqlite3 "${DB}" "SELECT canonical FROM site WHERE rowid = ${INITIAL_DOMAIN_ID};")"
if [[ ${CONTAINER_IS_IN_PWD} == true ]]; then POST_DOMAIN="ip$(ip a s eth1 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2 | sed 's/\./\-/g')-${SESSION_ID}-${PWD_PORT}.direct.${PWD_HOST_FQDN}"; fi

# check variable and status
# terminate if domain is not set
if [ -z "${POST_DOMAIN}" ]; then
	exit 0
else
	# terminate if domain already exist
	if sqlite3 "${DB}" "SELECT canonical FROM site;" | grep -q "${POST_DOMAIN}"; then
		exit 0
	fi
fi

# update domain for nginx
sudo chown -R amusewiki:amusewiki /etc/nginx/sites-enabled
sed "s/${INITIAL_DOMAIN}/${POST_DOMAIN}/g" /etc/nginx/sites-enabled/${NGX_PREFIX} > /tmp/${NGX_PREFIX}
cp /tmp/${NGX_PREFIX} /etc/nginx/sites-enabled || exit 1
sudo chown -R root:root /etc/nginx/sites-enabled

# update domain for database
sqlite3 "${DB}" "update site SET canonical = '${POST_DOMAIN}' WHERE canonical = '${INITIAL_DOMAIN}';"
