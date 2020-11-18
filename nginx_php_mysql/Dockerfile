FROM alpine:3.7
RUN adduser -D -u 1000 -g 1000 -s /bin/sh nginx && \
    mkdir -p /var/www/html && \
    chown -R nginx:nginx /var/www /var/www/html
RUN apk add --no-cache --update \
    gettext \
    git \
    openssh \
    mysql \
    openrc \
    mysql-client \
    nginx && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /run/nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/lib/nginx /var/www && \
    chown -R nginx:nginx /var/tmp/nginx /run/nginx
RUN addgroup mysql mysql
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

COPY ./php-fpm-www.conf /etc/php7/php-fpm.d/www.conf
COPY ./nginx.conf.template /nginx.conf.template
COPY ./nginx.conf /etc/nginx/conf.d/
COPY scripts/start.sh /usr/local/bin/start.sh
EXPOSE 80 3306
WORKDIR /var/www/html
ENTRYPOINT [ "sh", "/usr/local/bin/start.sh" ]
