ARG PHP_IMAGE_TAG="8.1"
ARG ENVIRONMENT=""
FROM php:${PHP_IMAGE_TAG} AS v1_2

RUN apt-get update && apt-get install -y mariadb-client openssh-client zlib1g-dev zip libpng-dev libzip-dev
RUN docker-php-ext-install -j$(nproc) pdo_mysql zip

RUN test ! -f /usr/sbin/apache2 || a2enmod rewrite

FROM v1_2 AS v1_3

RUN apt-get install -y sendmail libjpeg-dev libjpeg62-turbo-dev libfreetype6-dev
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
    || docker-php-ext-configure gd --with-freetype --with-jpeg --with-png \
    || docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN test "5.6" = ${PHP_IMAGE_TAG} || pecl install xdebug

