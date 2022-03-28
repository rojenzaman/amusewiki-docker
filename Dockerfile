FROM nginx:latest
RUN apt-get update && apt-get upgrade -y
# Install all dependencies
# Note: fontconfig must be installed before texlive-full
RUN apt-get install -y fontconfig
RUN apt-get install -y sqlite3 carton graphicsmagick imagemagick \
shared-mime-info openssl libssl-dev xapian-tools libxapian-dev unzip wget git \
rsync
RUN apt-get install -y texlive-full
RUN apt-get install -y cpanminus build-essential zlib1g-dev libpng-dev \
libjpeg-dev libxml2-dev libexpat1-dev
# Quality of Life utils
RUN apt-get install -y sudo vim
# Create amusewiki user
RUN apt-get clean
RUN useradd -ms /bin/bash amuse
RUN adduser amuse sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# Some additional nginx config
RUN mkdir /etc/nginx/sites-enabled
# Switch to amusewiki user and install
USER amuse
WORKDIR /home/amuse
RUN git clone https://github.com/melmothx/amusewiki.git
WORKDIR /home/amuse/amusewiki
RUN ./script/install.sh
#Permissions right now are wide open. Please consider to chown it to
#www-data (or whatever user is running fcgiwrap, and restore it to a
#sensible 755.
RUN cp dbic.yaml.sqlite.example dbic.yaml
#TODO: make hostname configurable
RUN ./script/configure.sh localhost > details.txt
USER root
RUN cat /tmp/nginx-amusewiki-*/amusewiki_include > /etc/nginx/amusewiki_include
RUN cat /tmp/nginx-amusewiki-*/amusewiki > /etc/nginx/sites-enabled/amusewiki
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/*
USER amuse
ENV AMW_WORKERS=5

# Right now you need to execute these commands in the container once it runs
#sudo service nginx start
#./init-all.sh start
