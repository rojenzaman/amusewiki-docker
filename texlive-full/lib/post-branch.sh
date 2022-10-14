#!/bin/bash

# terminate if branch is not set
if [ -z ${AMUSEWIKI_SWITCH_BRANCH} ]; then
	exit 0
else
	git -C /var/lib/amusewiki pull
	git -C /var/lib/amusewiki switch ${AMUSEWIKI_SWITCH_BRANCH}
fi
