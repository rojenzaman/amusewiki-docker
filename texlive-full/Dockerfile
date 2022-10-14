FROM debian:latest

# temporarily disable posix shell:
RUN mv /bin/sh /bin/sh.local && ln -s /bin/bash /bin/sh

# install requirements
RUN apt-get update && apt-get upgrade -y; \
	apt-get install -y \
		wget curl gnupg2 build-essential bash-completion nano file net-tools psmisc procps htop python3 sudo \
		sqlite3 fontconfig carton openssh-server; \
	apt-get install --no-install-recommends --no-install-suggests -y \
		graphicsmagick imagemagick shared-mime-info openssl libssl-dev xapian-tools libxapian-dev unzip wget git rsync \
		cpanminus build-essential zlib1g-dev libpng-dev libjpeg-dev libxml2-dev libexpat1-dev nginx; \
	apt-get install -y texlive-full

# set locales
RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# install amusewiki tools and fonts
RUN wget -O - https://packages.amusewiki.org/amusewiki.gpg.key | apt-key add -; \
        echo 'deb http://packages.amusewiki.org/debian bullseye main' > /etc/apt/sources.list.d/amusewiki.list; \
        apt-get update; \
        apt-get install -y libtext-amuse-perl libtext-amuse-preprocessor-perl libtext-amuse-compile-perl amusewiki-extra-fonts

# install fake systemd
RUN git clone https://github.com/gdraheim/docker-systemctl-replacement /tmp/docker-systemctl-replacement; \
	cd /tmp/docker-systemctl-replacement; \
	make; \
	cp files/docker/systemctl3.py /usr/bin/systemctl; \
	ln -sf /usr/bin/systemctl /bin/systemctl || true
COPY lib/bash_completion/systemctl /etc/bash_completion.d

# amusewiki nginx compatible
RUN rm -rf /etc/nginx/sites-enabled /etc/nginx/sites-available /etc/nginx/conf.d; \
	mkdir -p /etc/nginx/sites-enabled /etc/nginx/conf.d; \
	echo -e "\
include /etc/nginx/sites-enabled/*; \n\
client_max_body_size 8m; \
" > /etc/nginx/conf.d/post-amuse.conf; \
# post nginx settings \
        sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# create amusewiki user and give sudo
RUN adduser --home /var/lib/amusewiki amusewiki --disabled-password --gecos ""; \
	echo 'amusewiki ALL=NOPASSWD: /bin/mv,/usr/bin/unlink,/bin/rm,/bin/sh,/bin/cp,/bin/chmod,/bin/sed' >> /etc/sudoers.d/amusewiki-temp; \
	echo 'amusewiki ALL=NOPASSWD: /bin/chown,/usr/sbin/nginx,/usr/sbin/amusewiki,/usr/bin/systemctl,/usr/bin/apt' >> /etc/sudoers.d/amusewiki; \
	chmod 0440 /etc/sudoers.d/amusewiki-temp /etc/sudoers.d/amusewiki

# quality of life
RUN echo "PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]# \[\e[0m\]'" >> ${HOME}/.bashrc; \
	echo "alias ls='ls --color=auto'" >> ${HOME}/.bashrc; \
	echo "source /etc/bash_completion" >> ${HOME}/.bashrc; \
	# db directory support \
	mkdir -p /var/lib/dbconfig-common/sqlite3/amusewiki; \
	ln -s /var/lib/amusewiki/sqlite.db /var/lib/dbconfig-common/sqlite3/amusewiki/amusewiki; \
	ln -s /var/lib/amusewiki/dbic.yaml /var/lib/dbconfig-common/sqlite3/amusewiki/dbic.yaml

# Switch to amusewiki user and install
ARG AMUSE_CLONE_COMMAND
RUN mv /var/lib/amusewiki /tmp; \
	${AMUSE_CLONE_COMMAND}; \
	cp -rp /tmp/amusewiki /var/lib/amusewiki && rm -rf /tmp/amusewiki; \ 
	chown -R amusewiki:amusewiki /var/lib/amusewiki
USER amusewiki
WORKDIR /var/lib/amusewiki
ARG AMUSE_BUILD_DOMAIN
ARG AMW_USERNAME
ARG AMW_PASSWORD
RUN ./script/install.sh || true; \
	cp dbic.yaml.sqlite.example dbic.yaml; \
	carton exec script/configure.sh ${AMUSE_BUILD_DOMAIN} > details.txt; \
	carton exec script/amusewiki-generate-nginx-conf | sudo /bin/sh; \
	\
	# set systemd files
	carton exec script/generate-systemd-unit-files ./var/tmp/systemd; \
	sudo cp -v ./var/tmp/systemd/* /etc/systemd/system/; \
	sudo chown root:root /etc/systemd/system/amusewiki-*; \
	sudo chmod 664 /etc/systemd/system/amusewiki-*; \
	# change amusewiki password \
	carton exec script/amusewiki-reset-password ${AMW_USERNAME} ${AMW_PASSWORD}

# set ENTRYPOINT
ARG AMW_WORKERS
ARG AMW_NPROC
ENV AMW_WORKERS=${AMW_WORKERS:-5}
ENV AMW_NPROC=${AMW_NPROC:-5}
RUN sudo systemctl enable amusewiki-web amusewiki-jobber nginx; \
	sudo mv /var/lib/amusewiki/script/amusewiki-jobber /var/lib/amusewiki/script/amusewiki-jobber-exec; \
	sudo sed -i 's/--nproc 5/--nproc ${AMW_NPROC}/g' /etc/systemd/system/amusewiki-web.service
COPY lib/amusewiki-jobber /var/lib/amusewiki/script
COPY lib/post-domain.sh /usr/bin
COPY lib/post-nginx.sh /usr/bin
COPY lib/post-password.sh /usr/bin
COPY lib/post-ssh.sh /usr/bin
COPY lib/amusewiki-jobber.service /etc/systemd/system
CMD ["/usr/bin/systemctl"]

# quality of life
RUN echo "PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]$ \[\e[0m\]'" >> /var/lib/amusewiki/.bashrc; \
	echo "alias ls='ls --color=auto'" >> /var/lib/amusewiki/.bashrc; \
	echo "source /etc/bash_completion" >> /var/lib/amusewiki/.bashrc; \
	source /etc/bash_completion; \
	# generate ssh key \
	ssh-keygen -q -t rsa -N '' -f /var/lib/amusewiki/.ssh/id_rsa <<<y >/dev/null 2>&1
ENV PS1='\[\e[0;38;5;247m\][\[\e[0;92m\]\u\[\e[0;38;5;247m\]@\[\e[0;93m\]\H \[\e[0;91m\]\W\[\e[0;38;5;247m\]]\[\e[0;38;5;247m\]$ \[\e[0m\]'
ENV AMW_USERNAME=${AMW_USERNAME}
ENV AMW_PASSWORD=${AMW_PASSWORD}
COPY lib/backup_amw.sh /usr/bin
COPY lib/re-configure-nginx.sh /usr/bin

# set amusewiki nginx prefix
ENV NGX_PREFIX=amusewiki

# restore posix shell
RUN sudo -S unlink /bin/sh && sudo -S mv /bin/sh.local /bin/sh; \
	sudo -S rm -f /etc/sudoers.d/amusewiki-temp
