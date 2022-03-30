#!/bin/bash
# replace OCI in ENV
. ENV &>/dev/null

case "${1}" in
	Dockerfile.centos|centos) ${OCI} build -t rojen/amusewiki:centos -f Dockerfile.centos . ;;
	Dockerfile.debian|debian) ${OCI} build -t rojen/amusewiki:debian -f Dockerfile.debian . ;;
	Dockerfile.debian-texlive|debian-texlive|latest) ${OCI} build -t rojen/amusewiki:latest -t rojen/amusewiki:debian-texlive -f Dockerfile.debian-texlive . ;;
	Dockerfile.fedora|fedora) ${OCI} build -t rojen/amusewiki:fedora -f Dockerfile.fedora . ;;
	Dockerfile.rockylinux|rockylinux|rocky) ${OCI} build -t rojen/amusewiki:rockylinux -f Dockerfile.rockylinux . ;;
	*)
		${OCI} build -t rojen/amusewiki:centos -f Dockerfile.centos .
		${OCI} build -t rojen/amusewiki:debian -f Dockerfile.debian .
		${OCI} build -t rojen/amusewiki:latest -t rojen/amusewiki:debian-texlive -f Dockerfile.debian-texlive .
		${OCI} build -t rojen/amusewiki:fedora -f Dockerfile.fedora .
		${OCI} build -t rojen/amusewiki:rockylinux -f Dockerfile.rockylinux .
	;;
esac
