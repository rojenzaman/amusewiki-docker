#!/bin/bash

mv lib/containerless-backup/amusewiki/nginx/amusewikidebian lib/containerless-backup/amusewiki/nginx/amusewiki

sed -i '
s/amusewikidebian_include/amusewiki_include/g
s/amusewikidebian.crt/amusewiki.crt/g
s/amusewikidebian.key/amusewiki.key/g
' lib/containerless-backup/amusewiki/nginx/amusewiki

grep -Fxq "listen 80;" lib/containerless-backup/amusewiki/nginx/amusewiki || {
	sed -i '/listen/d' lib/containerless-backup/amusewiki/nginx/amusewiki
	sed -i 's/server {/server { listen 80; listen [::]:80; listen 443 ssl; listen [::]:443 ssl;/g' lib/containerless-backup/amusewiki/nginx/amusewiki
}
