#!/bin/sh
/opt/rabbitmq/sbin/rabbitmq-plugins enable --offline rabbitmq_management
/opt/rabbitmq/sbin/rabbitmq-server
