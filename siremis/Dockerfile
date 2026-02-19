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
        pgsql \
        pdo_pgsql \
        xml \
        gd \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Clone Siremis and prepare directory structure
RUN git clone --depth 1 https://github.com/asipto/siremis-php.git /var/www/html/siremis \
    && cd /var/www/html/siremis \
    && make prepare \
    && mkdir -p /var/www/html/siremis/siremis/session \
    && chown -R www-data:www-data /var/www/html/siremis

# Apache virtual host configuration
COPY apache-siremis.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]
