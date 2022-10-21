#!/bin/bash

if [[ "${UPDATE_AMUSEWIKI}" == "true" ]]; then
	set -x
	sudo apt install -y amusewiki-extra-fonts
	sudo apt install -y --no-install-recommends amusewiki postgresql-
fi
