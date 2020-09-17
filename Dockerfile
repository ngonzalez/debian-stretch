ARG TAG=stretch
FROM debian:${TAG}

# systemd
RUN echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/debian-backports.list
RUN apt-get update -yq
RUN apt-get dist-upgrade -yq
RUN apt-get -t stretch-backports install -y --no-install-recommends systemd systemd-sysv
FROM debian:${TAG}
COPY --from=0 / /
ENV container docker
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock" ]

# Timezone
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Base Packages
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
RUN apt-get install -yq dialog libreadline-dev pkg-config
RUN apt-get install -yq ca-certificates curl
RUN apt-get install -yq libssl-dev openssl

# locales
RUN apt-get install -yq locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf
RUN locale-gen en_US.UTF-8

# APP_USER
ENV APP_USER=debian
RUN echo "APP_USER=$APP_USER" > /etc/profile.d/app_user.sh
RUN useradd -m -p $(openssl passwd -1 password) $APP_USER -s /bin/bash
RUN apt-get install -yq sudo
RUN echo "$APP_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN curl -fsSL https://git.io/JUROW -o /home/$APP_USER/.bashrc

# ssh
ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get install -yq openssh-client openssh-server

RUN mkdir -p /home/$APP_USER/.ssh
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

# git
RUN apt-get install -yq git-core
RUN git config --global core.editor vim
RUN git config --global core.pager less
RUN curl -fsSL https://git.io/JURsx -o /home/$APP_USER/.gitconfig
RUN mkdir -p /usr/local/git
RUN chown $APP_USER: /usr/local/git
RUN runuser -l $APP_USER -c "git clone git@github.com:git/git.git /usr/local/git &>/dev/null"
RUN apt-get install -yq cmake
RUN cd /usr/local/git/contrib/diff-highlight && make
RUN cp -r /usr/local/git/contrib/diff-highlight /usr/share/git-core/contrib/diff-highlight

# vim
RUN apt-get install -yq vim
RUN	curl -fsSL https://git.io/JUROM -o /etc/vim/vimrc.local
RUN echo "GIT_EDITOR=vim" > /etc/profile.d/git.sh

# rsyslog
RUN apt-get install -yq rsyslog
# RUN echo "*.* @@127.0.0.1:4000" > /etc/rsyslog.d/logstash.conf

# system init
CMD [ "/sbin/init" ]
