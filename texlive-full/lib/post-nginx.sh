#!/bin/bash

# set fastcgi_param
if [[ "${CONTAINER_IS_BEHIND_HTTPS_TRAEFIK}" == true ]]; then
	if grep -Pq "fastcgi_param.*HTTPS.*on;" /etc/nginx/${NGX_PREFIX}_include; then
		exit 0
	else
		sudo chown -R amusewiki:amusewiki /etc/nginx
		sed 's/fastcgi_param\(.*\)HTTPS\(.*\)/fastcgi_param HTTPS on;/g' /etc/nginx/${NGX_PREFIX}_include > /tmp/${NGX_PREFIX}_include
		cp /tmp/${NGX_PREFIX}_include /etc/nginx || { sudo chown -R root:root /etc/nginx; exit 1; }
		sudo chown -R root:root /etc/nginx
		exit 0
	fi
fi

if [[ "${CONTAINER_IS_BEHIND_HTTPS_TRAEFIK}" == false ]]; then
	if grep -Pq 'fastcgi_param.*HTTPS.*if_not_empty' /etc/nginx/${NGX_PREFIX}_include; then
		exit 0
	else
		sudo chown -R amusewiki:amusewiki /etc/nginx
		sed 's/fastcgi_param\(.*\)HTTPS\(.*\)/fastcgi_param HTTPS $https if_not_empty;/g' /etc/nginx/${NGX_PREFIX}_include > /tmp/${NGX_PREFIX}_include
		cp /tmp/${NGX_PREFIX}_include /etc/nginx || { sudo chown -R root:root /etc/nginx; exit 1; }
		sudo chown -R root:root /etc/nginx
		exit 0
	fi
fi
