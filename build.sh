#!/bin/bash
# replace OCI in ENV
. ENV &>/dev/null

case "${1}" in
	Dockerfile.debian|debian) ${OCI} build -t rojen/amusewiki:debian -f Dockerfile.debian . ;;
	Dockerfile.debian-texlive|debian-texlive|latest) ${OCI} build -t rojen/amusewiki:latest -t rojen/amusewiki:debian-texlive -f Dockerfile.debian-texlive . ;;
	Dockerfile.fedora|fedora) ${OCI} build -t rojen/amusewiki:fedora -f Dockerfile.fedora . ;;
	Dockerfile.almalinux|almalinux|alma) ${OCI} build -t rojen/amusewiki:almalinux -f Dockerfile.almalinux . ;;
	*)
		${OCI} build -t rojen/amusewiki:debian -f Dockerfile.debian .
		${OCI} build -t rojen/amusewiki:latest -t rojen/amusewiki:debian-texlive -f Dockerfile.debian-texlive .
		${OCI} build -t rojen/amusewiki:fedora -f Dockerfile.fedora .
		${OCI} build -t rojen/amusewiki:almalinux -f Dockerfile.almalinux .
	;;
esac
