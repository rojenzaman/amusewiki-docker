FROM debian:latest

# temporarily disable posix shell:
RUN mv /bin/sh /bin/sh.local && ln -s /bin/bash /bin/sh

# install requirements
RUN apt-get update && apt-get upgrade -y; \
	apt-get install -y \
		wget curl gnupg2 build-essential bash-completion nano file net-tools psmisc procps htop \
		nginx git python3 sudo sqlite3

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
COPY lib/bash_completion/systemctl /etc/bash_completion.d


# install amusewiki from source
ENV DEBIAN_FRONTEND noninteractive
RUN wget -O - https://packages.amusewiki.org/amusewiki.gpg.key | apt-key add -; \
	echo 'deb http://packages.amusewiki.org/debian bullseye main' > /etc/apt/sources.list.d/amusewiki.list; \
	apt-get update; \
	apt-get install -y amusewiki-extra-fonts; \
	apt-get install -y --no-install-recommends amusewiki postgresql-; \
	chmod g+s /var/lib/amusewiki
ENV DEBIAN_FRONTEND newt

# quality of life
ARG AMW_WORKERS
RUN echo "PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]# \[\e[0m\]'" >> ${HOME}/.bashrc \
	echo "alias ls='ls --color=auto'" >> ${HOME}/.bashrc; \
	echo "source /etc/bash_completion" >> ${HOME}/.bashrc; \
	echo "export AMW_WORKERS=${AMW_WORKERS}" > /etc/profile.d/amusewiki_worker.sh

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
RUN usermod -aG sudo amusewiki; \
	#echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	echo 'ALL ALL=NOPASSWD: /bin/mv,/usr/bin/unlink,/bin/rm' >> /etc/sudoers.d/amusewiki-temp; \
	echo 'ALL ALL=NOPASSWD: /bin/chown,/usr/sbin/nginx,/usr/sbin/amusewiki,/usr/bin/systemctl,/usr/bin/apt' >> /etc/sudoers.d/amusewiki; \
	chmod 0440 /etc/sudoers.d/amusewiki-temp /etc/sudoers.d/amusewiki

# install nginx configuration
RUN cat /tmp/nginx-amusewiki-*/amusewikidebian_include > /etc/nginx/amusewikidebian_include; \
	cat /tmp/nginx-amusewiki-*/amusewikidebian > /etc/nginx/sites-enabled/amusewikidebian

# set ENTRYPOINT
RUN systemctl enable amusewiki-web amusewiki-jobber nginx; \
	mv /usr/bin/amusewiki-jobber /usr/bin/amusewiki-jobber-exec
COPY lib/amusewiki-jobber /usr/bin
COPY lib/post-domain.sh /usr/bin
COPY lib/post-nginx.sh /usr/bin
CMD ["/usr/bin/systemctl"]

# quality of life
USER amusewiki
WORKDIR /var/lib/amusewiki
RUN echo "PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]$ \[\e[0m\]'" >> /var/lib/amusewiki/.bashrc; \
	echo "alias ls='ls --color=auto'" >> /var/lib/amusewiki/.bashrc; \
	echo "source /etc/bash_completion" >> /var/lib/amusewiki/.bashrc; \
	echo "export AMW_WORKERS=${AMW_WORKERS}" >> /var/lib/amusewiki/.bashrc; \
	source /etc/bash_completion
ENV PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]$ \[\e[0m\]'
ENV AMW_WORKERS=${AMW_WORKERS}

# set amusewiki nginx prefix
ENV NGX_PREFIX=amusewikidebian

# restore posix shell
RUN sudo -S unlink /bin/sh && sudo -S mv /bin/sh.local /bin/sh; \
	sudo -S rm -f /etc/sudoers.d/amusewiki-temp
