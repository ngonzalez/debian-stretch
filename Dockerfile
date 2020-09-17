ARG  TAG=stretch
FROM debian:${TAG}

RUN echo "deb http://deb.debian.org/debian stretch-backports main" > \
	/etc/apt/sources.list.d/debian-backports.list

RUN apt-get update
RUN apt-get dist-upgrade -y
ENV DEBIAN_FRONTEND=noninteractive

# systemd
RUN apt-get -t stretch-backports install -y --no-install-recommends systemd systemd-sysv
FROM debian:${TAG}
COPY --from=0 / /
ENV container docker
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock" ]

# Base packages
RUN apt-get -t stretch-backports install -y --no-install-recommends \
	ca-certificates curl libreadline-dev libssl-dev openssl pkg-config rsyslog

# Locales
RUN apt-get -t stretch-backports install -y --no-install-recommends locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf
RUN locale-gen en_US.UTF-8

# Add APP_USER
ENV APP_USER=debian
RUN echo "APP_USER=debian" > /etc/profile.d/app_user.sh
RUN . /etc/profile.d/app_user.sh
RUN useradd -m -p $(openssl passwd -1 password) $APP_USER -s /bin/bash
RUN apt-get -t stretch-backports install -y --no-install-recommends sudo
RUN echo "$APP_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN curl -fsSL https://git.io/JUROW -o /home/$APP_USER/.bashrc

# Setup SSH
ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get -t stretch-backports install -y --no-install-recommends \
	openssh-client openssh-server

RUN mkdir -p /home/$APP_USER/.ssh && \
	chmod 700 /home/$APP_USER/.ssh && \
	chown $APP_USER: /home/$APP_USER/.ssh && \
	ssh-keyscan github.com > /home/$APP_USER/.ssh/known_hosts

RUN ssh-keygen -q -t rsa -N '' -f /home/$APP_USER/.ssh/id_rsa && \
	chmod 600 /home/$APP_USER/.ssh/id_rsa && \
	chmod 644 /home/$APP_USER/.ssh/id_rsa.pub

RUN echo "$ssh_prv_key" > /home/$APP_USER/.ssh/host && \
	echo "$ssh_pub_key" > /home/$APP_USER/.ssh/host.pub && \
	chmod 600 /home/$APP_USER/.ssh/host && \
	chmod 644 /home/$APP_USER/.ssh/host.pub && \
	cp /home/$APP_USER/.ssh/host.pub /home/$APP_USER/.ssh/authorized_keys

RUN curl -fsSL https://git.io/JURY9 -o /home/$APP_USER/.ssh/config

CMD [ "/sbin/init" ]
