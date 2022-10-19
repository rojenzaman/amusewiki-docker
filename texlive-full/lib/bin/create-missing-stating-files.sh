#!/bin/bash

if [[ "${CREATE_MISSING_STAGING_FILES}" == true ]]; then
	while IFS= read -r staging_path; do
		if [[ ! -f "${staging_path}" ]]; then
			staging_dir="$(dirname "${staging_path}")"
			mkdir -p "${staging_dir}"
			echo "#title missing staging file" > "${staging_path}"
		fi
	done < <(grep -Po '/var/lib/amusewiki/staging.*?muse' /var/lib/amusewiki/log/amw.log | sort -u)
fi
