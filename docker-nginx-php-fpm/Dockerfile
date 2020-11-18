FROM alpine:3.7
RUN adduser -D -u 1000 -g 1000 -s /bin/sh nginx && \
    mkdir -p /var/www/html && \
    chown -R nginx:nginx /var/www /var/www/html
RUN apk add --no-cache --update tini
# Install a golang port of supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord
# Install nginx & gettext (envsubst)
# Create cachedir and fix permissions
RUN apk add --no-cache --update \
    gettext \
    nginx && \
    mkdir -p /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/lib/nginx /var/www  && \
    chown -R nginx:nginx /var/tmp/nginx
# Install PHP/FPM + Modules
RUN apk add --no-cache --update \
    php7 \
    php7-apcu \
    php7-bcmath \
    php7-bz2 \
    php7-cgi \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-oauth \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-phar \
    php7-redis \
    php7-session \
    php7-simplexml \
    php7-tokenizer \
    php7-xdebug \
    php7-xml \
    php7-xmlwriter \
    php7-zip \
    php7-zlib \
    php7-zmq 
ENV SERVER_NAME="localhost"
ENV SERVER_ALIAS=""
ENV SERVER_ROOT=/var/www/html
COPY ./supervisord.conf /supervisord.conf
COPY ./php-fpm-www.conf /etc/php7/php-fpm.d/www.conf
COPY ./nginx.conf.template /nginx.conf.template
COPY ./nginx.conf /etc/nginx/conf.d/
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80
WORKDIR /var/www/html
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
