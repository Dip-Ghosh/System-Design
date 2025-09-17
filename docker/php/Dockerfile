
FROM php:8.2-fpm-alpine

# System deps
RUN apk add --no-cache \
    git curl zip unzip icu-dev oniguruma-dev libpng-dev libjpeg-turbo-dev libzip-dev \
    bash shadow

# PHP extensions
RUN docker-php-ext-configure gd --with-jpeg \
 && docker-php-ext-install -j$(nproc) pdo_mysql bcmath intl gd zip exif pcntl

#RUN apt-get update && apt-get install -y \
#    libzip-dev \
#    zip \
#    unzip \
#    git \
#    curl \
#    autoconf \
#    pkg-config \
#    libssl-dev \
#    build-essential \
#    && pecl install redis \
#    && docker-php-ext-enable redis \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*
#
## Install Redis extension via PECL 👇
#RUN pecl install redis \
#    && docker-php-ext-enable redis
#
## Verify Redis is installed
#RUN php -m | grep redis


# Opcache (good even in dev)
RUN docker-php-ext-install opcache

# Composer (copy from official image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Match container user to typical host UID:GID (1000)
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

WORKDIR /var/www

# (Optional) Pre-create writable dirs for first run
RUN mkdir -p storage bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
