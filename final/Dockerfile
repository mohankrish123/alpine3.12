FROM alpine:3.7

# Installing ssh
RUN apk --update --no-cache add openssh \
    && ssh-keygen -A 
 
# Installing nginx, php, mysql
RUN adduser -D -u 1000 -g 1000 -s /bin/sh nginx && \
    echo 'nginx:nginx' | chpasswd && \
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
    chown -R nginx:nginx /var/tmp/nginx /run/nginx && \
    rm -rf /etc/nginx/conf.d/default.conf
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

# Installing Elasticsearch
RUN apk update && apk --no-cache add wget bash\
    openjdk8-jre \
    su-exec \
    ca-certificates \
    && cd /tmp \
    && wget --progress=bar:force -O elasticsearch.tar.gz "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.16.tar.gz" \
    && tar -xf elasticsearch.tar.gz \
    && mkdir -p /usr/share/elasticsearch \
    && mv elasticsearch-5.6.16/* /usr/share/elasticsearch \
    && adduser -D -h /usr/share/elasticsearch elasticsearch \
    && rm -rf /tmp/elasticsearch.tar.gz
RUN sed -ie 's/-Xms2g/-Xms256m/g' /usr/share/elasticsearch/config/jvm.options
RUN sed -ie 's/-Xmx2g/-Xmx256m/g' /usr/share/elasticsearch/config/jvm.options
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
ENV PATH /usr/share/elasticsearch/bin:$PATH
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

# Installing Redis
RUN apk --update --no-cache add redis
COPY redis.conf /etc/redis.conf

# Installing Rabbitmq
RUN addgroup -S rabbitmq && adduser -S -h /var/lib/rabbitmq -G rabbitmq rabbitmq
RUN apk add --no-cache \
# Procps for rabbitmqctl
                procps \
# Erlang for RabbitMQ
                erlang-asn1 \
                erlang-hipe \
                erlang-crypto \
                erlang-eldap \
                erlang-inets \
                erlang-mnesia \
                erlang \
                erlang-os-mon \
                erlang-public-key \
                erlang-sasl \
                erlang-ssl \
                erlang-syntax-tools \
                erlang-xmerl \
    && mkdir -p /opt/rabbitmq \
    && wget -O rabbitmq-server.tar.xz "https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_6_12/rabbitmq-server-generic-unix-3.6.12.tar.xz" \
    && tar --extract --verbose --file rabbitmq-server.tar.xz --directory /opt/rabbitmq --strip-components 1 \
    && rm -f rabbitmq-server.tar.xz \
    && mkdir -p /var/lib/rabbitmq /etc/rabbitmq && chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq && chmod -R 777 /var/lib/rabbitmq /etc/rabbitmq
ENV PATH /opt/rabbitmq/sbin:$PATH

# Installing Varnish
RUN apk --update --no-cache add varnish
COPY default.vcl /etc/varnish/default.vcl

EXPOSE 3306 9000 6379 80 22 5672 15672 9200 9300 8080

ENTRYPOINT [ "sh", "/usr/local/bin/start.sh" ]
