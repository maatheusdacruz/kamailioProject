FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install FreeSWITCH 1.10 from SignalWire packages.
# Requires a free SignalWire Personal Access Token: https://signalwire.com/signin
# Set via build arg: docker build --build-arg SIGNALWIRE_TOKEN=<token> .
ARG SIGNALWIRE_TOKEN
RUN test -n "$SIGNALWIRE_TOKEN" || (echo "ERROR: SIGNALWIRE_TOKEN build arg is required" && false)

RUN apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 wget ca-certificates curl \
    && wget -qO /usr/share/keyrings/signalwire-freeswitch-repo.gpg \
        https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg \
    && echo "machine freeswitch.signalwire.com login signalwire password ${SIGNALWIRE_TOKEN}" \
        > /etc/apt/auth.conf \
    && echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] \
        https://freeswitch.signalwire.com/repo/deb/debian-release/ bookworm main" \
        > /etc/apt/sources.list.d/freeswitch.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        freeswitch-meta-vanilla \
        freeswitch-mod-curl \
        freeswitch-mod-commands \
    && rm -rf /var/lib/apt/lists/* /etc/apt/auth.conf

COPY config/ /etc/freeswitch/

# SIP port for media server (Kamailio → FreeSWITCH)
# ESL control port (internal)
EXPOSE 5080/udp 5080/tcp 8021/tcp

CMD ["freeswitch", "-nf", "-nonat", "-c"]
