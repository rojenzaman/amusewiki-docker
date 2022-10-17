#!/bin/bash
# ports:
#   - '6022:22'
# host ssh config:
#   host amusewiki.localdomain
#   hostname 127.0.0.1
#   StrictHostKeyChecking no
#   user amusewiki
#   port 6022

# generate new ssh key if enabled
if [ "${GENERATE_NEW_SSH_KEY}" == "true" ]; then
	ssh-keygen -q -t rsa -N '' -f /var/lib/amusewiki/.ssh/id_rsa <<<y >/dev/null 2>&1
fi

# terminate if public key is not set
if [ -z "${HOST_SSH_PUBLIC_KEY}" ]; then
	exit 0
else
	# write ssh key
	echo "${HOST_SSH_PUBLIC_KEY}" > /var/lib/amusewiki/.ssh/authorized_keys
	# enable and start sshd service
	sudo systemctl enable sshd
	sudo systemctl start sshd
fi
