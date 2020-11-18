FROM alpine:3.7

RUN apk --update --no-cache add redis

COPY startup.sh /usr/local/bin/startup.sh

COPY redis.conf /etc/redis.conf

ENTRYPOINT ["sh","/usr/local/bin/startup.sh"]



