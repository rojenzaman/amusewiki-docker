FROM debian:latest

# temporarily disable posix shell:
RUN mv /bin/sh /bin/sh.local && ln -s /bin/bash /bin/sh

# install requirements
RUN apt-get update && apt-get upgrade -y; \
	apt-get install -y \
		wget curl gnupg2 build-essential bash-completion nano file net-tools psmisc procps htop jq rsync \
		nginx-extras git python3 sudo sqlite3 openssh-server

# set locales
RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# install fake systemd
RUN git clone https://github.com/gdraheim/docker-systemctl-replacement /tmp/docker-systemctl-replacement; \
	cd /tmp/docker-systemctl-replacement; \
	make; \
	cp files/docker/systemctl3.py /usr/bin/systemctl; \
	ln -sf /usr/bin/systemctl /bin/systemctl || true

# install amusewiki from source
ENV DEBIAN_FRONTEND noninteractive
RUN wget -O - https://packages.amusewiki.org/amusewiki.gpg.key | apt-key add -; \
	echo 'deb http://packages.amusewiki.org/debian bullseye main' > /etc/apt/sources.list.d/amusewiki.list; \
	apt-get update; \
	apt-get install -y amusewiki-extra-fonts; \
	apt-get install -y --no-install-recommends amusewiki postgresql-; \
	chmod g+s /var/lib/amusewiki
ENV DEBIAN_FRONTEND=

# local requirements
RUN echo "PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]# \[\e[0m\]'" >> ${HOME}/.bashrc \
	echo "alias ls='ls --color=auto'" >> ${HOME}/.bashrc; \
	echo "source /etc/bash_completion" >> ${HOME}/.bashrc

# amusewiki nginx compatible
RUN rm -rf /etc/nginx/sites-enabled /etc/nginx/sites-available /etc/nginx/conf.d; \
	mkdir -p /etc/nginx/sites-enabled /etc/nginx/conf.d; \
	echo -e "\
include /etc/nginx/sites-enabled/*; \n\
client_max_body_size 8m; \
" > /etc/nginx/conf.d/post-amuse.conf; \
# post nginx settings \
	sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# give sudo to amusewiki
RUN echo 'amusewiki ALL=NOPASSWD: /bin/mv,/usr/bin/unlink,/bin/rm' >> /etc/sudoers.d/amusewiki-temp; \
	echo 'amusewiki ALL=NOPASSWD: /bin/chown,/usr/sbin/nginx,/usr/sbin/amusewiki,/usr/bin/systemctl,/usr/bin/apt,/bin/chmod' >> /etc/sudoers.d/amusewiki; \
	chmod 0440 /etc/sudoers.d/amusewiki-temp /etc/sudoers.d/amusewiki

# install nginx configuration
RUN cat /tmp/nginx-amusewiki-*/amusewikidebian_include > /etc/nginx/amusewikidebian_include; \
	cat /tmp/nginx-amusewiki-*/amusewikidebian > /etc/nginx/sites-enabled/amusewikidebian

# set ENTRYPOINT
ARG AMW_WORKERS
ARG AMW_NPROC
ENV AMW_WORKERS=${AMW_WORKERS:-5}
ENV AMW_NPROC=${AMW_NPROC:-5}
RUN systemctl enable amusewiki-web amusewiki-jobber nginx; \
	mv /usr/bin/amusewiki-jobber /usr/bin/amusewiki-jobber-exec; \
	sed -i 's/--nproc 5/--nproc ${AMW_NPROC}/g' /lib/systemd/system/amusewiki-web.service
# starting the application with systemd
CMD ["/usr/bin/systemctl"]

# copy entities to its home
COPY lib/bash_completion.d /etc/bash_completion.d
COPY lib/bin /usr/bin

# local requirements
USER amusewiki
WORKDIR /var/lib/amusewiki
ARG AMW_USERNAME
ARG AMW_PASSWORD
RUN echo "PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]$ \[\e[0m\]'" >> /var/lib/amusewiki/.bashrc; \
	echo "alias ls='ls --color=auto'" >> /var/lib/amusewiki/.bashrc; \
	echo "source /etc/bash_completion" >> /var/lib/amusewiki/.bashrc; \
	source /etc/bash_completion; \
	# change amusewiki password \
	amusewiki-reset-password ${AMW_USERNAME} ${AMW_PASSWORD}; \
	# generate ssh key \
	ssh-keygen -q -t rsa -N '' -f /var/lib/amusewiki/.ssh/id_rsa <<<y >/dev/null 2>&1
ENV PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]$ \[\e[0m\]'
ENV AMW_USERNAME=${AMW_USERNAME}
ENV AMW_PASSWORD=${AMW_PASSWORD}
ARG AMW_SQLITE_PATH
ENV AMW_SQLITE_PATH=${AMW_SQLITE_PATH:-/var/lib/dbconfig-common/sqlite3/amusewiki/amusewiki}
ENV OTHER_VOLUMES_USED_IN_CONTAINER="/var/lib/amusewiki/log, /var/lib/amusewiki/ssl, /var/lib/amusewiki/.ssh"

# set amusewiki nginx prefix
ENV NGX_PREFIX=amusewikidebian

# restore posix shell
RUN sudo -S unlink /bin/sh && sudo -S mv /bin/sh.local /bin/sh; \
	sudo -S rm -f /etc/sudoers.d/amusewiki-temp
