FROM alpine:3.12

RUN addgroup -S rabbitmq && adduser -S -h /var/lib/rabbitmq -G rabbitmq rabbitmq
RUN apk update && apk add --no-cache \
# Procps for rabbitmqctl
                procps \
# Erlang for RabbitMQ
		erlang \
    && mkdir -p /opt/rabbitmq \
    && wget -O rabbitmq-server.tar.xz "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.5/rabbitmq-server-generic-unix-latest-toolchain-3.8.5.tar.xz" \
    && tar --extract --verbose --file rabbitmq-server.tar.xz --directory /opt/rabbitmq --strip-components 1 \
    && rm -f rabbitmq-server.tar.xz \
    && mkdir -p /var/lib/rabbitmq /etc/rabbitmq && chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq && chmod -R 777 /var/lib/rabbitmq /etc/rabbitmq 

COPY startup.sh /usr/local/bin/startup.sh
ENV PATH /opt/rabbitmq/sbin:$PATH
EXPOSE 5672 15672
CMD ["sh","/usr/local/bin/startup.sh"]


