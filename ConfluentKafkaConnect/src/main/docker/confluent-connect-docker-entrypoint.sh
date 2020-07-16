#!/bin/sh
#set -e

sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/KAFKA_CONNECT_CLUSTER_GROUP_ID/$KAFKA_CONNECT_CLUSTER_GROUP_ID/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/KAFKA_CONNECT_KEY_CONVERTOR/$KAFKA_CONNECT_KEY_CONVERTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/KAFKA_CONNECT_VALUE_CONVERTOR/$KAFKA_CONNECT_VALUE_CONVERTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/SCHEMA_REGISTRY_URL/$SCHEMA_REGISTRY_URL/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_CONFIGS_TOPIC/$CONNECT_CONFIGS_TOPIC/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_OFFSETS_TOPIC/$CONNECT_OFFSETS_TOPIC/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_STATUSES_TOPIC/$CONNECT_STATUSES_TOPIC/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONFIG_STORAGE_REPLICATION_FACTOR/$CONFIG_STORAGE_REPLICATION_FACTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/OFFSET_STORAGE_REPLICATION_FACTOR/$OFFSET_STORAGE_REPLICATION_FACTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/STATUS_STORAGE_REPLICATION_FACTOR/$STATUS_STORAGE_REPLICATION_FACTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_HOST/$CONNECT_HOST/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_PORT/$CONNECT_PORT/" /usr/local/confluent/config/connect-avro-distributed.properties

echo "Starting Kafka Connect Cluster on $CONNECT_HOST:$CONNECT_PORT"
connect-distributed /usr/local/confluent/config/connect-avro-distributed.properties