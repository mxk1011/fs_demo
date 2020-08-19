FROM debian:buster-slim

ENV EC2 false
ENV SOFTTIMER_TIMERFD true
ENV DEFAULT_PASSWORD 1234
ENV DEBIAN_FRONTEND noninteractive

# Install freeswitch repo
RUN apt-get update && \
apt-get dist-upgrade -y && \
apt-get install -y --no-install-recommends curl gnupg gnupg2 lsb-release && \
curl -k https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - && \
echo 'deb http://files.freeswitch.org/repo/deb/debian-release/ buster main' > /etc/apt/sources.list.d/freeswitch.list && \
apt-get update

# Install freeswitch package
# Note, the additional packages are installed for use case reasons:
# - xmlstarlet for XML manipulation via ENTRYPOINT
# - git for overly configuration from a git repository
# - vim for dev/test editing in the fs container
RUN apt-get install -y --no-install-recommends xmlstarlet git vim freeswitch-conf-curl freeswitch-mod-b64 freeswitch-mod-blacklist freeswitch-mod-cdr-csv freeswitch-mod-cdr-sqlite freeswitch-mod-cidlookup freeswitch-mod-commands freeswitch-mod-conference freeswitch-mod-console freeswitch-mod-curl freeswitch-mod-db freeswitch-mod-dialplan-xml freeswitch-mod-dptools freeswitch-mod-enum freeswitch-mod-event-socket freeswitch-mod-expr freeswitch-mod-fifo freeswitch-mod-format-cdr freeswitch-mod-fsv freeswitch-mod-g723-1 freeswitch-mod-g729 freeswitch-mod-graylog2 freeswitch-mod-hash freeswitch-mod-httapi freeswitch-mod-json-cdr freeswitch-mod-local-stream freeswitch-mod-logfile freeswitch-mod-loopback freeswitch-mod-lua freeswitch-mod-native-file freeswitch-mod-opus freeswitch-mod-posix-timer freeswitch-mod-prefix freeswitch-mod-python freeswitch-mod-radius-cdr freeswitch-mod-random freeswitch-mod-rtc freeswitch-mod-sndfile freeswitch-mod-snmp freeswitch-mod-sofia freeswitch-mod-spandsp freeswitch-mod-spy freeswitch-mod-syslog freeswitch-mod-timerfd freeswitch-mod-tone-stream freeswitch-mod-valet-parking freeswitch-mod-xml-cdr freeswitch-mod-xml-curl freeswitch-mod-xml-rpc freeswitch-mod-yaml freeswitch-timezones freeswitch-conf-vanilla freeswitch freeswitch-mod-av dumb-init freeswitch-mod-v8 freeswitch-sounds-en-us-callie freeswitch-sounds-fr-ca-june freeswitch-mod-say-en freeswitch-mod-say-fr freeswitch-mod-flite freeswitch-mod-sms freeswitch-music-default freeswitch-mod-verto freeswitch-mod-png freeswitch-mod-esf freeswitch-mod-h26x freeswitch-mod-voicemail freeswitch-mod-voicemail-ivr freeswitch-mod-callcenter freeswitch-mod-dialplan-asterisk freeswitch-mod-amr curl

# Install dummy certificate
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y -q --no-install-recommends \
        ssl-cert openssh-server net-tools dnsutils

RUN cat /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key > /etc/freeswitch/tls/wss.pem
RUN cat /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key > /etc/freeswitch/tls/agent.pem
RUN cat /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key > /etc/freeswitch/tls/dtls-srtp.pem
RUN cat /etc/ssl/certs/ssl-cert-snakeoil.pem > /etc/freeswitch/tls/dtls-srtp.crt

# Cleanup
RUN apt-get remove --purge -y gnupg && \
        apt-get clean autoclean && \
        apt-get autoremove --yes && \
        rm -rf /var/lib/{apt,dpkg,cache,log}/

#VOLUME /etc/freeswitch
VOLUME /var/lib/freeswitch
VOLUME /var/log/freeswitch
VOLUME /usr/share/freeswitch

EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5066/tcp 7443/tcp
EXPOSE 8021/tcp

# RTP port range
EXPOSE 16384-32768/udp

COPY entrypoint.sh /opt/local/bin/entrypoint.sh
COPY reload.sh /opt/local/bin/reload.sh
COPY config /etc/freeswitch
COPY scripts /usr/share/freeswitch/scripts
COPY fonts /usr/share/freeswitch/fonts

ENTRYPOINT ["/opt/local/bin/entrypoint.sh"]

CMD ["freeswitch", "-c", "-nf"]