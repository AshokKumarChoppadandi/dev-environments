#!/bin/sh
#set -e

sed -i -e "s/HOSTNAME/$HOSTNAME/" /usr/local/confluent/config/server.properties
sed -i -e "s/HOSTNAME/$HOSTNAME/" /usr/local/confluent/config/schema-registry.properties
sed -i -e "s/HOSTNAME/$HOSTNAME/" /usr/local/confluent/config/connect-avro-distributed.properties

echo "Starting Zookeeper...!!!"
nohup zookeeper-server-start /usr/local/confluent/config/zookeeper.properties > zookeeper.log 2>&1 &
echo "Sleeping for 30 Seconds...!!!"
sleep 30

echo "Starting Kafka Server / Broker...!!!"
nohup kafka-server-start /usr/local/confluent/config/server.properties > broker.log 2>&1 &
echo "Sleeping for 30 Seconds...!!!"
sleep 30

echo "Starting Confluent Schema Registry...!!!"
nohup schema-registry-start /usr/local/confluent/config/schema-registry.properties > registry.log 2>&1 &
echo "Sleeping for 30 Seconds...!!!"
sleep 30

echo "Starting kafka Connect Cluster in Distributed Mode...!!!"
nohup connect-distributed /usr/local/confluent/config/connect-avro-distributed.properties > connect.log 2>&1 &
# connect-distributed /usr/local/confluent/config/connect-avro-distributed.properties

exec "$@"
