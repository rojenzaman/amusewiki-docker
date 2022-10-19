#!/bin/bash
if [ ! -f /etc/nginx/sites-enabled/${NGX_PREFIX} ]; then if [ -f /etc/nginx/amusewikidebian_include ]; then export NGX_PREFIX=amusewikidebian; fi; if [ -f /etc/nginx/amusewiki_include ]; then export NGX_PREFIX=amusewiki; fi; fi

rm -rf /tmp/nginx-amusewiki-*
carton exec ./script/amusewiki-generate-nginx-conf
if [ -d /tmp/nginx-amusewiki-*/ ]; then
	sudo chown -R amusewiki:amusewiki /etc/nginx
	cat /tmp/nginx-amusewiki-*/${NGX_PREFIX} > /etc/nginx/sites-enabled/${NGX_PREFIX}
	sudo chown -R root:root /etc/nginx
fi
sudo systemctl restart nginx
