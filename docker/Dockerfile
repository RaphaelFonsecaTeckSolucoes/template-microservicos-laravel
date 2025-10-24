ARG PHP_VERSION

FROM php:${PHP_VERSION} AS base

ARG HOST_UID=HOST_UID
ARG HOST_GID=HOST_GID

## Diretório da aplicação
ARG APP_DIR=/var/www/app

## Versão da Lib do Redis para PHP
ARG REDIS_LIB_VERSION=6.1.0

### apt-utils é um extensão de recursos do gerenciador de pacotes APT
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    apt-utils \
    sudo \
    supervisor

# dependências recomendadas de desenvolvido para ambiente linux
RUN apt-get update && apt-get install -y \
    autoconf \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    zlib1g-dev \
    sqlite3 \
    libsqlite3-dev 

RUN docker-php-ext-install pdo session xml

# habilita instalação do Redis
RUN pecl install redis-${REDIS_LIB_VERSION} \
    && docker-php-ext-enable redis 

RUN docker-php-ext-install bcmath zip iconv simplexml pcntl gd fileinfo pdo pdo_mysql

# habilita instalação do xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# habilita instalação do opentelemetry
RUN pecl install opentelemetry \
    && docker-php-ext-enable opentelemetry

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./docker/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

### Supervisor permite monitorar e controlar vários processos (LINUX)
### Bastante utilizado para manter processos em Daemon, ou seja, executando em segundo plano

COPY ./docker/php/extra-php.ini /usr/local/etc/php/conf.d/99_extra.ini
COPY ./docker/php/extra-php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

RUN usermod -u ${HOST_UID} www-data && groupmod -g ${HOST_GID} www-data

FROM base AS app

WORKDIR $APP_DIR

# Copie o resto dos arquivos
COPY . .

# Instale as dependências.
RUN composer install --no-interaction --optimize-autoloader

# Instalação do Nginx
RUN apt-get install nginx -y \
    && rm -rf /etc/nginx/sites-enabled/* \
    && rm -rf /etc/nginx/sites-available/*
COPY ./docker/nginx/sites.conf /etc/nginx/sites-enabled/default.conf
COPY ./docker/nginx/error.html /var/www/html/error.html

# Node.js
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs nano git


# Copia e dá permissão ao entrypoint como root
COPY ./docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN echo "umask 0000" >> /root/.bashrc
RUN echo "umask 0000" >> /etc/profile

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]