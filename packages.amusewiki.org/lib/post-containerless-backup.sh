#!/bin/bash

mv lib/containerless-backup/amusewiki/nginx/amusewiki lib/containerless-backup/amusewiki/nginx/amusewikidebian

sed -i '
s/amusewiki_include/amusewikidebian_include/g
s/amusewiki.crt/amusewikidebian.crt/g
s/amusewiki.key/amusewikidebian.key/g
' lib/containerless-backup/amusewiki/nginx/amusewikidebian

grep -Fxq "listen 80;" lib/containerless-backup/amusewiki/nginx/amusewikidebian || {
	sed -i '/listen/d' lib/containerless-backup/amusewiki/nginx/amusewikidebian
	sed -i 's/server {/server { listen 80; listen [::]:80; listen 443 ssl; listen [::]:443 ssl;/g' lib/containerless-backup/amusewiki/nginx/amusewikidebian
}
