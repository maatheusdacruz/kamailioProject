FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Kamailio 5.7 from official packages + PostgreSQL client for kamdbctl
RUN set -e; \
    apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 wget ca-certificates gettext-base \
    && wget -qO - https://deb.kamailio.org/kamailiodebkey.gpg | apt-key add - \
    && echo "deb http://deb.kamailio.org/kamailio57 bookworm main" \
        > /etc/apt/sources.list.d/kamailio.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        kamailio \
        kamailio-postgres-modules \
        kamailio-redis-modules \
        kamailio-extra-modules \
        kamailio-utils-modules \
        kamailio-json-modules \
        kamailio-xml-modules \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

COPY config/ /etc/kamailio/
COPY kamctlrc /opt/kamctlrc
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

# SIP port (behind HAProxy, listens on 5061)
# JSONRPC port for Siremis (5064)
EXPOSE 5061/udp 5061/tcp 5064/tcp

ENTRYPOINT ["/opt/entrypoint.sh"]
