# Example showing how to test this:
#   docker build --build-arg PHP_IMAGE=php:8.2 --target v2_1 --tag test:8.2 .
ARG PHP_IMAGE="php"
FROM ${PHP_IMAGE} AS v1_2

LABEL org.opencontainers.image.authors="krato@krato.cz"

RUN apt-get update && apt-get install -y mariadb-client openssh-client zlib1g-dev zip libpng-dev libzip-dev
RUN docker-php-ext-install -j$(nproc) pdo_mysql zip

RUN test ! -f /usr/sbin/apache2 || a2enmod rewrite

ARG PHP_IMAGE="php"
FROM v1_2 AS v1_3

RUN apt-get install -y sendmail libjpeg-dev libjpeg62-turbo-dev libfreetype6-dev
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
    || docker-php-ext-configure gd --with-freetype --with-jpeg --with-png \
    || docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN ( echo "${PHP_IMAGE}" | grep "php:5." ) \
    || ( ( echo "${PHP_IMAGE}" | grep "php:7." ) && pecl install xdebug-3.1.6 ) \
    || pecl install xdebug

ARG PHP_IMAGE="php"
FROM v1_3 AS v2_0

RUN apt-get purge -y sendmail
RUN apt-get install -y libmemcached-dev
RUN ( echo "${PHP_IMAGE}" | grep "php:5." ) || ( pecl install memcached && docker-php-ext-enable memcached )
RUN ( echo "${PHP_IMAGE}" | grep "php:5." ) || ( pecl install redis && docker-php-ext-enable redis )
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-enable gd mysqli

FROM v2_0 AS v2_1

RUN test ! -f /usr/sbin/apache2 || a2enmod rewrite remoteip

RUN test ! -f /usr/sbin/apache2 || ( echo "RemoteIPHeader X-Forwarded-For" ; echo "RemoteIPInternalProxy 172.0.0.0/8" ) > /etc/apache2/mods-enabled/remoteip.conf

FROM v2_1 AS latest
