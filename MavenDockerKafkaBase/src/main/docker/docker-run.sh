docker run -idt \
-e ZOOKEEPER_DATA_DIR="\/usr\/local\/confluent\/zookeeper" \
-e ZOOKEEPER_CLIENT_PORT=2181 \
-e ZOOKEEPER_TICK_TIME=2000 \
-e BROKER_ID=0 \
-e KAFKA_LISTENERS="PLAINTEXT:\/\/0.0.0.0:9092" \
-e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT:\/\/broker:9092" \
-e KAFKA_DATA_DIRS="\/usr\/local\/confluent\/data\/kafka-logs" \
-e DEFAULT_KAFKA_TOPIC_PARTITIONS=3 \
-e ZOOKEEPERS_LIST=broker:2181 \
-e CONNECT_HOST=broker \
-e CONNECT_PORT=8083 \
-e KAFKA_CONNECT_CLUSTER_GROUP_ID=connect-cluster \
-e KAFKA_CONNECT_KEY_CONVERTOR=org.apache.kafka.connect.json.JsonConverter \
-e KAFKA_CONNECT_VALUE_CONVERTOR=org.apache.kafka.connect.json.JsonConverter \
-e SCHEMA_REGISTRY_URL="http:\/\/broker:8081" \
-e CONNECT_CONFIGS_TOPIC=connect_configs \
-e CONNECT_OFFSETS_TOPIC=connect_offsets \
-e CONNECT_STATUSES_TOPIC=connect_statuses \
-e CONFIG_STORAGE_REPLICATION_FACTOR=1 \
-e OFFSET_STORAGE_REPLICATION_FACTOR=1 \
-e STATUS_STORAGE_REPLICATION_FACTOR=1 \
-p 9092:9092 -p 8081:8081 -p 8082:8082 -p 8083:8083 \
--hostname broker --name broker ashokkumarchoppadandi/confluent-kafka-base:latest sh

docker exec -it broker sh

sed -i -e "s/ZOOKEEPER_HOST/$ZOOKEEPER_HOST/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_CLIENT_PORT/$ZOOKEEPER_CLIENT_PORT/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_DATA_DIR/$ZOOKEEPER_DATA_DIR/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_TICK_TIME/$ZOOKEEPER_TICK_TIME/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/BROKER_ID/$BROKER_ID/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_LISTENERS/$KAFKA_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_DATA_DIRS/$KAFKA_DATA_DIRS/" /usr/local/confluent/config/server.properties
sed -i -e "s/DEFAULT_KAFKA_TOPIC_PARTITIONS/$DEFAULT_KAFKA_TOPIC_PARTITIONS/" /usr/local/confluent/config/server.properties
sed -i -e "s/ZOOKEEPERS_LIST/$ZOOKEEPERS_LIST/" /usr/local/confluent/config/server.properties
sed -i -e "s/CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS/$CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS/" /usr/local/confluent/config/server.properties
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
sed -i -e "s/ZOOKEEPERS_LIST/$ZOOKEEPERS_LIST/" /usr/local/confluent/config/schema-registry.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/schema-registry.properties


nohup zookeeper-server-start /usr/local/confluent/config/zookeeper.properties > zookeeper.log 2>&1 &
nohup kafka-server-start /usr/local/confluent/config/server.properties > broker.log 2>&1 &
nohup connect-distributed /usr/local/confluent/config/connect-avro-distributed.properties > connect.log 2>&1 &
nohup schema-registry-start /usr/local/confluent/config/schema-registry.properties > registry.log 2>&1 &

kafka-topics --bootstrap-server broker:9092 --list
kafka-topics --bootstrap-server broker:9092 --create --topic my-avro-test --replication-factor 1 --partitions 3

kafka-avro-console-producer --broker-list broker:9092 --topic my-avro-test --property schema.registry.url="http://broker:8081" --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"}]}'

curl -X GET http://localhost:8081/subjects
curl -X GET http://localhost:8081/subjects/<INSERT SUBJECT NAME>-value/versions/
curl -X GET http://localhost:8081/subjects/<INSERT SUBJECT NAME>-value/versions/1
curl -X GET http://localhost:8081/subjects/<INSERT SUBJECT NAME>-value/versions/latest
curl -X GET http://localhost:8081/schemas/ids/<VERSION_ID>