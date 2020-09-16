ARG  TAG=stretch
FROM debian:${TAG}

RUN echo "deb http://deb.debian.org/debian stretch-backports main" > \
	/etc/apt/sources.list.d/debian-backports.list

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get -t stretch-backports install -y --no-install-recommends \
	systemd systemd-sysv

FROM debian:${TAG}
COPY --from=0 / /
ENV container docker
STOPSIGNAL SIGRTMIN+3

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock" ]

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -t stretch-backports install -y --no-install-recommends \
	pkg-config libreadline-dev ca-certificates curl \
	openssh-client openssh-server openssl libssl-dev

RUN curl -fsSL https://gist.githubusercontent.com/ngonzalez/106e8ac9f0358e4388c0b3496adf771c/raw/e78e617a07dd8ed4b88ec95b450972bc96da577e/install.sh -o /install.sh
RUN chmod +x install.sh
RUN . /install.sh

CMD [ "/sbin/init" ]
