#!/bin/bash -x

sudo chown -R amusewiki:amusewiki /etc/nginx/sites-enabled

sed -i '
s/amusewikidebian_include/amusewiki_include/g
s/amusewikidebian.crt/amusewiki.crt/g
s/amusewikidebian.key/amusewiki.key/g
' amusewiki/nginx/amusewiki*

mv /etc/nginx/sites-enabled/amusewikidebian /etc/nginx/sites-enabled/amusewiki
sudo chown -R root:root /etc/nginx/sites-enabled
