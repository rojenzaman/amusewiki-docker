#!/bin/bash
# ports:
#   - '6022:22'
# host ssh config:
#   host amusewiki.localdomain
#   hostname 127.0.0.1
#   user amusewiki
#   port 6022

# terminate if public key is not set
if [ -z "${HOST_SSH_PUBLIC_KEY}" ]; then
	exit 0
else
	# write ssh key
	echo "${HOST_SSH_PUBLIC_KEY}" > /var/lib/amusewiki/.ssh/authorized_keys
fi
