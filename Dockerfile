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

CMD [ "/sbin/init" ]