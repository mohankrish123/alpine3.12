FROM alpine:3.7

LABEL MAINTAINER="Mohan Krishna <mohankrishnav@kensium.com>"
LABEL APP="mariadb"
LABEL APP_REPOSITORY="https://pkgs.alpinelinux.org/package/edge/main/aarch64/mysql"

ENV TIMEZONE Europe/Paris
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_DATABASE app
ENV MYSQL_USER app
ENV MYSQL_PASSWORD app
ENV MYSQL_USER_MONITORING monitoring
ENV MYSQL_PASSWORD_MONITORING monitoring

# Installing packages MariaDB
RUN apk update && \
    apk --update --no-cache add mysql mysql-client openrc
RUN addgroup mysql mysql

# Work path
WORKDIR /scripts

# Copy of the MySQL startup script
COPY scripts/start.sh start.sh
RUN chmod 777 start.sh

# Creating the persistent volume
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT [ "./start.sh" ]
