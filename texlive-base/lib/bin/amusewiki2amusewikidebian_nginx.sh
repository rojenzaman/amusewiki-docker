#!/bin/bash -x

sudo chown -R amusewiki:amusewiki /etc/nginx/sites-enabled

sed -i '
s/amusewiki_include/amusewikidebian_include/g
s/amusewiki.crt/amusewikidebian.crt/g
s/amusewiki.key/amusewikidebian.key/g
' /etc/nginx/sites-enabled/amusewiki*

mv /etc/nginx/sites-enabled/amusewiki /etc/nginx/sites-enabled/amusewikidebian
sudo chown -R root:root /etc/nginx/sites-enabled
