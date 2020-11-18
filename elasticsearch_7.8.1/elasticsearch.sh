#!/bin/sh
su - elasticsearch -c "env JAVA_HOME=/usr/lib/jvm/java-11-openjdk/jre /usr/share/elasticsearch/bin/elasticsearch"
