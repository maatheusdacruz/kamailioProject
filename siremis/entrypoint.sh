#!/bin/sh
set -e

APP_INC="/var/www/html/siremis/bin/app.inc"
if [ -f "$APP_INC" ]; then
  # Force root-based URLs to avoid /siremis asset 404s.
  sed -i "s|define('APP_URL',.*);|define('APP_URL',\"\");|" "$APP_INC"
fi

# PHP memory limit: 256M is sufficient now that the xmltoarray infinite
# recursion bug is fixed. 2048M per worker x 20 workers was unsustainable.
echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/siremis.ini

# Disable debug to reduce metadata churn and memory usage.
if [ -f "$APP_INC" ]; then
  sed -i -E "s|define\(\"DEBUG\",[[:space:]]*[0-9]+\);|define(\"DEBUG\", 0);|" "$APP_INC"
fi

# Clear caches to force clean metadata rebuild.
# Use find -delete so it works even when www-data owns the files.
find /var/www/html/siremis/modules/cache/ -mindepth 1 -delete 2>/dev/null || true
find /var/www/html/siremis/files/cache/ -mindepth 1 -delete 2>/dev/null || true
find /var/www/html/siremis/themes/default/template/cpl/ -mindepth 1 -delete 2>/dev/null || true

CONFIG_XML="/var/www/html/siremis/Config.xml"
if [ -f "$CONFIG_XML" ]; then
  # Ensure Siremis DB uses MySQL service hostname and correct credentials.
  sed -i -E 's|<Database Name="Default"[^>]*/>|<Database Name="Default" Driver="Pdo_Mysql" Server="mysql" Port="3306" DBName="siremis" User="siremis" Password="siremis" Charset="utf8"/>|g' "$CONFIG_XML"
  # Ensure SIP DB uses PostgreSQL service hostname and correct credentials.
  sed -i -E 's|<Database Name="Sipdb"[^>]*/>|<Database Name="Sipdb" Driver="Pdo_Pgsql" Server="postgres" Port="5432" DBName="kamailio" User="kamailio" Password="kamailio" Charset="utf8"/>|g' "$CONFIG_XML"
fi

# Mark Siremis as installed so the app skips the install wizard redirect.
# The DB is pre-seeded via siremis-modules.sql (MySQL docker-entrypoint-initdb.d).
touch /var/www/html/siremis/install.lock

exec apache2-foreground
