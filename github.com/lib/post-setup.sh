#!/bin/bash

sed -i '
s/amusewikidebian_include/amusewiki_include/g
s/amusewikidebian.crt/amusewiki.crt/g
s/amusewikidebian.key/amusewiki.key/g
' amusewiki/nginx/amusewiki*

mv amusewiki/nginx/amusewikidebian amusewiki/nginx/amusewiki
