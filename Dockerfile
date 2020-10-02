FROM ich777/debian-baseimage:armv7

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl screen && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/anope
ENV HOST="irc.example.com"
ENV IP_ADDR="192.168.1.1"
ENV SSL="no"
ENV PORT=7000
ENV PASSWORD="password"
ENV IRCD="inspircd3"
ENV CASEMAP="rfc1459"
ENV LOCAL_HOSTNAME="services"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="anope"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]