#!/bin/bash

targets="$(make -rpn | sed -n -e '/^$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$// ; p ; } ; }' | grep -v "\-\-" | sort -u)"

while IFS= read -r target; do
	targethelp="$(cat ".lib/makehelp/${target}" 2>/dev/null )"
	echo "+${target} +${targethelp}"
done <<< "${targets}" | column -t -s '+' | grep -v default
