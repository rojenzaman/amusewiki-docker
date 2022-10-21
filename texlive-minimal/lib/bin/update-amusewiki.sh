#!/bin/bash

if [[ "${UPDATE_AMUSEWIKI}" == "true" ]]; then
	# changed git source file is only: script/amusewiki-jobber
	set -x
	mv /var/lib/amusewiki/script/amusewiki-jobber /var/lib/amusewiki/script/amusewiki-jobber.local
	git -C /var/lib/amusewiki restore /var/lib/amusewiki/script/amusewiki-jobber
	git -C /var/lib/amusewiki pull --ff-only
	mv /var/lib/amusewiki/script/amusewiki-jobber /var/lib/amusewiki/script/amusewiki-jobber-exec
	mv /var/lib/amusewiki/script/amusewiki-jobber.local /var/lib/amusewiki/script/amusewiki-jobber
fi
