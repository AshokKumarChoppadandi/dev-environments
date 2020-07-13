#!/bin/sh
#set -e

echo "BROKER ID :::: ${BROKER_ID}"
sed -i -e "s/BROKER_ID/$BROKER_ID/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_LISTENERS/$KAFKA_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_DATA_DIRS/$KAFKA_DATA_DIRS/" /usr/local/confluent/config/server.properties
sed -i -e "s/DEFAULT_KAFKA_TOPIC_PARTITIONS/$DEFAULT_KAFKA_TOPIC_PARTITIONS/" /usr/local/confluent/config/server.properties
sed -i -e "s/ZOOKEEPERS_LIST/$ZOOKEEPERS_LIST/" /usr/local/confluent/config/server.properties
sed -i -e "s/CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS/$CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS/" /usr/local/confluent/config/server.properties

echo "Starting Kafka Broker on $KAFKA_ADVERTISED_LISTENERS"
kafka-server-start /usr/local/confluent/config/server.properties