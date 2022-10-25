#!/bin/bash
BACKUP_BASE="/tmp/amusewiki-backup_container"
#RSYNC_REPO_ARG="--exclude '*.pdf'"
RSYNC_DB_ARG="--copy-links"

# enable verbose
set -x

mkdir -p ${BACKUP_BASE}/amusewiki/db
mkdir -p ${BACKUP_BASE}/amusewiki/nginx

rsync ${RSYNC_DB_ARG} -radhzv --delete ${AMW_SQLITE_PATH} ${BACKUP_BASE}/amusewiki/db/amusewiki

rsync -radhzv --delete /etc/nginx/sites-enabled/amusewikidebian ${BACKUP_BASE}/amusewiki/nginx/ || {
	rsync -radhzv --delete /etc/nginx/sites-enabled/amusewiki ${BACKUP_BASE}/amusewiki/nginx/
}

rsync ${RSYNC_REPO_ARG} -radhzv --delete /var/lib/amusewiki/repo ${BACKUP_BASE}/amusewiki/

rsync -radhzv --delete /var/lib/amusewiki/staging ${BACKUP_BASE}/amusewiki/

rsync -radhzv --delete /var/lib/amusewiki/thumbnails ${BACKUP_BASE}/amusewiki/

if [[ ${OTHER_VOLUMES_USED_IN_CONTAINER} ]]; then
	for amw_object in ${OTHER_VOLUMES_USED_IN_CONTAINER//,/}; do
		if [[ ${amw_object} == /var/lib/amusewiki/* ]]; then
			if [[ -e ${amw_object} ]]; then
				if [[ -d ${amw_object} ]]; then
					amw_object_base=$(realpath ${amw_object} | cut -d'/' -f5-)
					mkdir -p ${BACKUP_BASE}/amusewiki/${amw_object_base}
					rsync -radhzv --delete /var/lib/amusewiki/${amw_object_base}/ ${BACKUP_BASE}/amusewiki/${amw_object_base}/
				fi
				if [[ -f ${amw_object} ]]; then
					amw_file_base=$(realpath ${amw_object} | cut -d'/' -f5-)
					amw_dir_base=$(dirname ${amw_object} | cut -d'/' -f5-)
					mkdir -p ${BACKUP_BASE}/amusewiki/${amw_dir_base}
					if [[ -z ${amw_dir_base} ]]; then
						rsync -radhzv --delete /var/lib/amusewiki/${amw_file_base} ${BACKUP_BASE}/amusewiki/
					else
						rsync -radhzv --delete /var/lib/amusewiki/${amw_file_base} ${BACKUP_BASE}/amusewiki/${amw_dir_base}/
					fi
				fi
			fi
		fi
	done
fi

tar -cvf ${BACKUP_BASE}/amusewiki.tar -C ${BACKUP_BASE} amusewiki/
