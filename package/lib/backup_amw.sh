#!/bin/bash
BACKUP_BASE="/tmp/amusewiki-backup_container"
#RSYNC_REPO_ARG="--exclude '*.pdf'"
RSYNC_DB_ARG="--copy-links"

mkdir -p ${BACKUP_BASE}/amusewiki/db
mkdir -p ${BACKUP_BASE}/amusewiki/nginx

rsync ${RSYNC_DB_ARG} -radhzv --delete ${AMW_SQLITE_PATH} ${BACKUP_BASE}/amusewiki/db/amusewiki

rsync -radhzv --delete /etc/nginx/sites-enabled/amusewikidebian ${BACKUP_BASE}/amusewiki/nginx/ || {
	rsync -radhzv --delete /etc/nginx/sites-enabled/amusewiki ${BACKUP_BASE}/amusewiki/nginx/
}

rsync ${RSYNC_REPO_ARG} -radhzv --delete /var/lib/amusewiki/repo ${BACKUP_BASE}/amusewiki/

rsync -radhzv --delete /var/lib/amusewiki/staging ${BACKUP_BASE}/amusewiki/

rsync -radhzv --delete /var/lib/amusewiki/thumbnails ${BACKUP_BASE}/amusewiki/

tar -cvf ${BACKUP_BASE}/amusewiki.tar -C ${BACKUP_BASE} amusewiki/
