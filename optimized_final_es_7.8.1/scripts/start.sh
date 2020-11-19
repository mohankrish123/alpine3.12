#!/bin/sh
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/ &
/usr/sbin/sshd -D &
/usr/sbin/crond &
nginx -g 'daemon off;' &
php-fpm7 &
su - elasticsearch -c "env JAVA_HOME=/usr/lib/jvm/java-11-openjdk/jre /usr/share/elasticsearch/bin/elasticsearch &"
redis-server /etc/redis.conf &
/opt/rabbitmq/sbin/rabbitmq-plugins enable --offline rabbitmq_management &
/opt/rabbitmq/sbin/rabbitmq-server &
varnishd -a ':80' -T 'localhost:6082' -f '/etc/varnish/default.vcl' -p 'http_resp_hdr_len=65536' -p 'http_resp_size=98304' -p 'vcc_allow_inline_c=on' -p 'workspace_backend=128k' -p 'workspace_client=128k' -s 'malloc,1G' &

echo "[i] Starting MySQL"
if [ ! -d "/run/mysqld" ]; then
  mkdir -p /run/mysqld
fi

if [ -d /var/lib/mysql/data ]; then
	echo "[i] Data directory exists"
else
	mkdir -p /var/lib/mysql/data
fi

if [ -d /var/lib/mysql/logs ]; then
        echo "[i] Logs directory exists"
else
        mkdir -p /var/lib/mysql/logs
fi


if [ -d /var/lib/mysql/data/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  mysql_install_db --user=root > /dev/null

  if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
    MYSQL_ROOT_PASSWORD=toor
    echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
  fi

  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'toor' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
EOF
    echo "[i] Creating database: magento"
    echo "CREATE DATABASE IF NOT EXISTS magento CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    echo "[i] Creating user: magento with password magento"
    echo "GRANT ALL ON *.* to 'root'@'localhost' IDENTIFIED BY 'toor';" >> $tfile
    echo "GRANT ALL ON magento.* to 'magento'@'%' IDENTIFIED BY 'magento';" >> $tfile
    echo "GRANT ALL ON magento.* to 'magento'@'localhost' IDENTIFIED BY 'magento';" >> $tfile
    echo "GRANT SUPER ON *.* to 'magento'@'localhost' IDENTIFIED BY 'magento';" >> $tfile

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile
fi


exec /usr/bin/mysqld --user=root --console

