#!/bin/bash
# volumes:
#   - '${HOME}/.ssh/id_rsa.pub:/etc/host-ssh.d/authorized_keys'
# ports:
#   - '6022:22'
# host ssh config:
#   host amusewiki.localdomain
#   hostname 127.0.0.1
#   user amusewiki
#   port 6022

if [ -f /etc/host-ssh.d/authorized_keys ]; then
        cp /etc/host-ssh.d/authorized_keys /var/lib/amusewiki/.ssh
fi
