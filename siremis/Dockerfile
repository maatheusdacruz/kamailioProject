# Siremis – Kamailio web management interface
# Based on PHP 7.4 + Apache (siremis-php supports up to PHP 7.x)
FROM php:7.4-apache

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP extensions required by Siremis
RUN apt-get update && apt-get install -y --no-install-recommends \
        libpq-dev \
        libxml2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git \
        make \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        pgsql \
        pdo_pgsql \
        xml \
        gd \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Increase PHP memory limit for Siremis
RUN echo "memory_limit = 2048M" > /usr/local/etc/php/conf.d/siremis.ini

# Clone Siremis and prepare directory structure
RUN git clone --depth 1 https://github.com/asipto/siremis-php.git /var/www/html/siremis-src \
    && cd /var/www/html/siremis-src \
    && make prepare \
    && cp -r /var/www/html/siremis-src/openbiz /var/www/html/ \
    && cp -r /var/www/html/siremis-src/siremis /var/www/html/ \
    && rm -rf /var/www/html/siremis-src \
    && mkdir -p /var/www/html/siremis/session \
    && chown -R www-data:www-data /var/www/html

# Apache virtual host configuration
COPY apache-siremis.conf /etc/apache2/sites-available/000-default.conf

# Limit Apache prefork workers to reduce memory usage
COPY apache-prefork.conf /etc/apache2/conf-available/siremis-prefork.conf
RUN a2enconf siremis-prefork

# Override login template to ensure login button renders
COPY overrides/login.tpl.html /var/www/html/siremis/modules/user/template/login.tpl.html

# Fix infinite recursion in xmltoarray.php for PHP 7+:
# Self-closing XML tags (<BizField/>) have type='complete' but no 'value' key.
# The original code fell through to recursive getchildren(), exhausting all RAM.
COPY overrides/xmltoarray.php /var/www/html/openbiz/bin/util/xmltoarray.php

# Fix ContactDO: remove the type_name JOIN that generates broken SQL (.name
# instead of T1.name) due to a PHP 7.4 interaction with the SQL builder.
COPY overrides/ContactDO.xml /var/www/html/siremis/modules/contact/do/ContactDO.xml

# Fix profileService: wrap the contact fetch in try/catch so a missing or
# broken contact table never prevents login from completing.
COPY overrides/profileService.php /var/www/html/siremis/modules/service/profileService.php

# Fix .htaccess RewriteBase: was /siremis/ but app is served from /
COPY overrides/htaccess /var/www/html/siremis/.htaccess

# Fix SQL quoting: getDBTableQuoted() always used MySQL backticks even for PostgreSQL.
# BizDataSql now accepts and stores the dbName, passing it to all getDBTableQuoted calls.
# BizDataObj_SQLHelper now passes $dataObj->m_Database to every getDBTableQuoted call.
COPY overrides/BizDataSql.php /var/www/html/openbiz/bin/data/BizDataSql.php
COPY overrides/BizDataObj_SQLHelper.php /var/www/html/openbiz/bin/data/private/BizDataObj_SQLHelper.php

# Ensure APP_URL stays root-based at container start
COPY entrypoint.sh /usr/local/bin/siremis-entrypoint
RUN chmod +x /usr/local/bin/siremis-entrypoint

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/siremis-entrypoint"]
CMD ["apache2-foreground"]
