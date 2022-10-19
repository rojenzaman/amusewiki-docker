#!/bin/bash

db-yaml() {
cat > /var/lib/amusewiki/dbic.yaml <<EOF
amuse:
  dsn: 'dbi:SQLite:${AMW_SQLITE_PATH}'
  user: ''
  password: ''
  on_connect_do: 'PRAGMA foreign_keys = ON'
  AutoCommit: 1
  RaiseError: 1
  sqlite_unicode: 1
  quote_names: 1
EOF
}

case ${1} in
	--force) db-yaml; exit 0;
esac

# terminate if path is not set
if [[ -z ${AMW_SQLITE_PATH} ]]; then
	exit 0
else
	# terminate if file not fount
	if [[ ! -f ${AMW_SQLITE_PATH} ]]; then
		exit 0
	else
		# give permission
		chmod 600 ${AMW_SQLITE_PATH}
		# print file if not set
		if grep -q "${AMW_SQLITE_PATH}" /var/lib/amusewiki/dbic.yaml; then
			exit 0
		else
			db-yaml
		fi
	fi
fi
