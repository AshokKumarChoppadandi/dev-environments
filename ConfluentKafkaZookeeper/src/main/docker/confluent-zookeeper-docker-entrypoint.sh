#!/bin/sh
#set -e

sed -i -e "s/ZOOKEEPER_HOST/$ZOOKEEPER_HOST/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_CLIENT_PORT/$ZOOKEEPER_CLIENT_PORT/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_DATA_DIR/$ZOOKEEPER_DATA_DIR/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_TICK_TIME/$ZOOKEEPER_TICK_TIME/" /usr/local/confluent/config/zookeeper.properties

echo "Starting Zookeeper on $ZOOKEEPER_HOST:$ZOOKEEPER_PORT"
zookeeper-server-start /usr/local/confluent/config/zookeeper.properties