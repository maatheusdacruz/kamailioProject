FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Kamailio 5.7 from official packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 wget ca-certificates \
    && wget -qO /usr/share/keyrings/kamailio.gpg \
        https://deb.kamailio.org/kamailiodebkey.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kamailio.gpg] \
        http://deb.kamailio.org/kamailio57 bookworm main" \
        > /etc/apt/sources.list.d/kamailio.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        kamailio \
        kamailio-postgres-modules \
        kamailio-redis-modules \
        kamailio-extra-modules \
        kamailio-utils-modules \
    && rm -rf /var/lib/apt/lists/*

COPY config/ /etc/kamailio/

# SIP port (behind HAProxy, so listens on 5061)
EXPOSE 5060/udp 5060/tcp

CMD ["kamailio", "-DD", "-E", "-e", "-f", "/etc/kamailio/kamailio.cfg"]
