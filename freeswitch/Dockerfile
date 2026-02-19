# FreeSWITCH installed from SignalWire Debian packages
# Requires SIGNALWIRE_TOKEN build arg (free PAT from signalwire.com)
FROM debian:bookworm-slim

ARG SIGNALWIRE_TOKEN
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 wget ca-certificates lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Add SignalWire FreeSWITCH package repository
RUN test -n "${SIGNALWIRE_TOKEN}" || { echo "ERROR: SIGNALWIRE_TOKEN build arg is required"; exit 1; } \
    && wget --quiet --http-user=signalwire --http-password=${SIGNALWIRE_TOKEN} \
        -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg \
        https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg \
    && echo "machine freeswitch.signalwire.com login signalwire password ${SIGNALWIRE_TOKEN}" \
        > /etc/apt/auth.conf \
    && echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ $(lsb_release -sc) main" \
        > /etc/apt/sources.list.d/freeswitch.list

# Install FreeSWITCH with required modules
RUN apt-get update && apt-get install -y --no-install-recommends \
        freeswitch \
        freeswitch-mod-commands \
        freeswitch-mod-console \
        freeswitch-mod-logfile \
        freeswitch-mod-sofia \
        freeswitch-mod-dptools \
        freeswitch-mod-dialplan-xml \
        freeswitch-mod-tone-stream \
        freeswitch-mod-sndfile \
        freeswitch-mod-native-file \
        freeswitch-mod-local-stream \
        freeswitch-mod-event-socket \
        freeswitch-mod-curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/apt/auth.conf

# Overlay custom configuration on top of package defaults
COPY config/ /etc/freeswitch/

# SIP port (Kamailio → FreeSWITCH) and ESL control port
EXPOSE 5080/udp 5080/tcp 8021/tcp

CMD ["freeswitch", "-nf", "-nonat", "-c"]
