FROM alpine:3.12

RUN apk update && apk --no-cache add wget bash\
    openjdk11-jre-headless \
    su-exec \
    && cd /tmp \
    && wget --progress=bar:force -O elasticsearch.tar.gz "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.6.2-no-jdk-linux-x86_64.tar.gz" \
    && tar -xf elasticsearch.tar.gz \
    && mkdir -p /usr/share/elasticsearch \
    && mv elasticsearch-7.6.2/* /usr/share/elasticsearch \
    && adduser -D -h /usr/share/elasticsearch elasticsearch \
    && export JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$(which javac || which java)")")") 
COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
ENV PATH /usr/share/elasticsearch/bin:$PATH
COPY elasticsearch.sh /usr/local/bin/elasticsearch.sh

RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
    
CMD ["sh","/usr/local/bin/elasticsearch.sh"]
