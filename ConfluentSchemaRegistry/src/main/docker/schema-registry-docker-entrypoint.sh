#!/bin/sh
#set -e

sed -i -e "s/ZOOKEEPERS_LIST/$ZOOKEEPERS_LIST/" /usr/local/confluent/config/schema-registry.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/schema-registry.properties

echo "Starting CONFLUENT SCHEMA REGISTRY...!!!"
schema-registry-start /usr/local/confluent/config/schema-registry.properties