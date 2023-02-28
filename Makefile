default:
	@true

clean-all:
	find -path './[^.]*' -prune -type d -exec make clean-all -C "{}" \;

chown:
	sudo chown -R ${USER}:${USER} .

rdfind:
	rdfind -makehardlinks true .

rdfind-clean:
	rdfind -makehardlinks false .

trigger-github-actions:
	git commit --allow-empty -m "trigger GitHub actions"
