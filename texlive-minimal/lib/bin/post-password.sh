#!/bin/bash
# set command
change_pass="carton exec script/amusewiki-reset-password"

# main
if [[ ${CHANGE_PASSWORD_BEFORE_RUN} == true ]]; then
	# terminate if AMW_PASSWORD is not set
	if [ -z "${AMW_PASSWORD}" ]; then
		exit 1
	else
		${change_pass} ${AMW_USERNAME:-amusewiki} ${AMW_PASSWORD}
	fi
fi
