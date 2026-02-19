#!/bin/bash
set -e

# Generate kamctlrc from template (write to home dir since /etc/kamailio is read-only)
envsubst < /opt/kamctlrc > /root/.kamctlrc

echo "Waiting for PostgreSQL..."
until pg_isready -h 127.0.0.1 -p 5432 -U "${DB_USER:-kamailio}" -q; do
    sleep 2
done
echo "PostgreSQL is ready."

# Check if Kamailio standard tables exist (version table)
export PGPASSWORD="${DB_PASS:-kamailio}"
if ! psql -h 127.0.0.1 -p 5432 -U "${DB_USER:-kamailio}" -d "${DB_NAME:-kamailio}" \
    -c "SELECT 1 FROM version LIMIT 1" >/dev/null 2>&1; then
    echo "Initializing Kamailio database tables..."
    echo "y" | kamdbctl create >/dev/null 2>&1 || true
    echo "Kamailio tables initialized."
else
    echo "Kamailio tables already exist."
fi
unset PGPASSWORD

echo "Starting Kamailio..."
exec kamailio -DD -E -e -f /etc/kamailio/kamailio.cfg
