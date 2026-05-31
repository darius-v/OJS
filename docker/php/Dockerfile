ARG PHP_VERSION=8.5

FROM php:${PHP_VERSION}-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        zip \
        libicu-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libxml2-dev \
        libxslt1-dev \
        libonig-dev \
        libcurl4-openssl-dev \
        libmagickwand-dev \
        default-mysql-client \
        cron \
        gettext \
        poppler-utils \
        antiword \
        catdoc \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        curl \
        exif \
        fileinfo \
        ftp \
        gd \
        intl \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        simplexml \
        sockets \
        xsl \
        xmlwriter \
        zip \
    && (docker-php-ext-install opcache || true) \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY docker/php/php.ini /usr/local/etc/php/conf.d/ojs.ini
COPY docker/php/entrypoint.sh /usr/local/bin/ojs-entrypoint

RUN chmod +x /usr/local/bin/ojs-entrypoint

WORKDIR /var/www/html

ENTRYPOINT ["ojs-entrypoint"]
CMD ["php-fpm"]
