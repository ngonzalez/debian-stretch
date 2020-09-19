ARG TAG=stretch
FROM debian:${TAG}

# debian
RUN apt-get update -yq
RUN apt-get dist-upgrade -yq

# env
ENV DEBIAN_FRONTEND noninteractive
ENV RUNLEVEL 1
ENV TERM xterm-256color

# debconf
RUN apt-get install -yq debconf dialog libreadline7 libreadline-dev
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg-reconfigure debconf

# debian backports
RUN echo "deb http://deb.debian.org/debian stretch-backports main" > \
	/etc/apt/sources.list.d/debian-backports.list
RUN apt-get update -yq && apt-get dist-upgrade -yq

# systemd
RUN apt-get -t stretch-backports install -y --no-install-recommends \
	systemd systemd-sysv
FROM debian:${TAG}
COPY --from=0 / /
ENV container docker
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock" ]

# locales
RUN apt-get install -yq locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf
RUN locale-gen en_US.UTF-8

# curl
RUN apt-get install -yq ca-certificates curl

# APP_USER
ENV APP_USER=debian
RUN echo "APP_USER=$APP_USER" > /etc/profile.d/app_user.sh
RUN useradd -m $APP_USER -s /bin/bash
RUN apt-get install -yq sudo
RUN echo "$APP_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# .bashrc
RUN curl -fsSL https://git.io/JUROW -o /root/.bashrc
RUN curl -fsSL https://git.io/JUROW -o /home/$APP_USER/.bashrc
RUN RUN chmod 644 /home/$APP_USER/.bashrc

# MOTD
RUN rm -f /etc/motd

# vim
RUN apt-get install -yq vim
RUN	curl -fsSL https://git.io/JUROM -o /etc/vim/vimrc.local
RUN echo "GIT_EDITOR=vim" > /etc/profile.d/git.sh

# Timezone
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

# ssh
ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get install -yq openssh-client openssh-server

RUN mkdir /home/$APP_USER/.ssh
RUN chmod 700 /home/$APP_USER/.ssh

RUN curl -fsSL https://git.io/JURcF -o /home/$APP_USER/.ssh/config
RUN chmod 644 /home/$APP_USER/.ssh/config

RUN ssh-keyscan github.com > /home/$APP_USER/.ssh/known_hosts
RUN chmod 644 /home/$APP_USER/.ssh/known_hosts

RUN ssh-keygen -q -t rsa -N '' -f /home/$APP_USER/.ssh/id_rsa
RUN chmod 600 /home/$APP_USER/.ssh/id_rsa
RUN echo " IdentityFile /home/$APP_USER/.ssh/id_rsa" >> /home/$APP_USER/.ssh/config
RUN chmod 644 /home/$APP_USER/.ssh/id_rsa.pub

RUN echo "$ssh_prv_key" > /home/$APP_USER/.ssh/id_host
RUN chmod 600 /home/$APP_USER/.ssh/id_host
RUN echo " IdentityFile /home/$APP_USER/.ssh/id_host" >> /home/$APP_USER/.ssh/config

RUN echo "$ssh_pub_key" > /home/$APP_USER/.ssh/id_host.pub
RUN chmod 644 /home/$APP_USER/.ssh/id_host.pub

RUN cp /home/$APP_USER/.ssh/id_host.pub /home/$APP_USER/.ssh/authorized_keys

RUN chown -R $APP_USER: /home/$APP_USER/.ssh

# elastic dependencies
RUN apt-get install -yq openjdk-8-jdk wget gnupg
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN apt-get install -yq apt-transport-https
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update -yq

# elasticsearch
RUN apt-get install -yq elasticsearch
RUN curl -fsSL https://git.io/JURi8 -o /etc/elasticsearch/elasticsearch.yml

# logstash
RUN apt-get install -yq logstash
RUN curl -fsSL https://git.io/JURiP -o /etc/logstash/conf.d/logstash.conf
RUN curl -fsSL https://git.io/JURi1 -o /etc/logstash/patterns

# kibana
RUN apt-get install -yq kibana
RUN curl -fsSL https://git.io/JURpA -o /etc/kibana/kibana.yml

# filebeat
RUN apt-get install -yq filebeat
RUN curl -fsSL https://git.io/JURhY -o /etc/filebeat/filebeat.yml

# rsyslog
RUN apt-get install -yq rsyslog
RUN echo "*.* @@127.0.0.1:4000" > /etc/rsyslog.d/logstash.conf

# Nginx
RUN apt-get install -yq nginx
RUN curl -fsSL https://git.io/JURpx -o /etc/nginx/sites-available/default

# system init
CMD [ "/sbin/init" ]
