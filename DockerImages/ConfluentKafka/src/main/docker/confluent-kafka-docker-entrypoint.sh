#!/bin/sh
#set -e

CONFIGS_DIR="/usr/local/configs"

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ zookeeper | kafka | connect | schemaregistry | ksqldb ]"
	echo "Stopping execution!"
	exit 1
}

LOG_FILE_PATH="$CONFLUENT_HOME"/logs/server.log

start_zookeeper() {
  echo "Starting Zookeeper..."

  # ZOOKEEPER PROPERTIES
  sed -i -e "s/ZOOKEEPER_DATA_DIR/$ZOOKEEPER_DATA_DIR/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_CLIENT_PORT/$ZOOKEEPER_CLIENT_PORT/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_MAX_CLIENT_CONNECTIONS/$ZOOKEEPER_MAX_CLIENT_CONNECTIONS/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_TICK_TIME/$ZOOKEEPER_TICK_TIME/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_ENABLE_SERVER/$ZOOKEEPER_ENABLE_SERVER/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_ADMIN_SERVER_PORT/$ZOOKEEPER_ADMIN_SERVER_PORT/" "${CONFIGS_DIR}"/zookeeper.properties

  "$CONFLUENT_HOME"/bin/zookeeper-server-start -daemon $CONFIGS_DIR/zookeeper.properties
  echo "Started Zookeeper Service..."
  sleep 10
  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/zookeeper.out
}

start_kafka_broker() {
  echo "Starting Kafka Broker..."

  # KAFKA BROKER / SERVER PROPERTIES
  sed -i -e "s/BROKER_ID/$BROKER_ID/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/KAFKA_LISTENERS/$KAFKA_LISTENERS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/NUM_NETWORK_THREADS/$NUM_NETWORK_THREADS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/NUM_IO_THREADS/$NUM_IO_THREADS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/SOCKET_SEND_BUFFER_BYTES/$SOCKET_SEND_BUFFER_BYTES/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/SOCKET_RECEIVE_BUFFER_BYTES/$SOCKET_RECEIVE_BUFFER_BYTES/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/SOCKET_REQUEST_MAX_BYTES/$SOCKET_REQUEST_MAX_BYTES/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/LOG_DIRS/$LOG_DIRS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/NUM_PARTITIONS/$NUM_PARTITIONS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/NUM_RECOVERY_THREADS_PER_DATA_DIR/$NUM_RECOVERY_THREADS_PER_DATA_DIR/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/OFFSETS_TOPIC_REPLICATION_FACTOR/$OFFSETS_TOPIC_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/TRANSACTION_STATE_LOG_REPLICATION_FACTOR/$TRANSACTION_STATE_LOG_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/TRANSACTION_STATE_LOG_MIN_ISR/$TRANSACTION_STATE_LOG_MIN_ISR/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/LOG_RETENTION_HOURS/$LOG_RETENTION_HOURS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/LOG_SEGMENT_BYTES/$LOG_SEGMENT_BYTES/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/LOG_RETENTION_CHECK_INTERVAL_MS/$LOG_RETENTION_CHECK_INTERVAL_MS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/ZOOKEEPER_CONNECT_LIST/$ZOOKEEPER_CONNECT_LIST/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/ZOOKEEPER_CONNECTION_TIMEOUT_MS/$ZOOKEEPER_CONNECTION_TIMEOUT_MS/" "${CONFIGS_DIR}"/server.properties
  sed -i -e "s/GROUP_INITIAL_REBALANCE_DELAY_MS/$GROUP_INITIAL_REBALANCE_DELAY_MS/" "${CONFIGS_DIR}"/server.properties

  "$CONFLUENT_HOME"/bin/kafka-server-start -daemon $CONFIGS_DIR/server.properties
  echo "Started kafka Service..."
  sleep 10
  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/server.log
}

start_schema_registry() {
  echo "Starting Schema Registry Service..."

  # SCHEMA REGISTRY PROPERTIES
  sed -i -e "s/SCHEMA_REGISTRY_LISTENERS/$SCHEMA_REGISTRY_LISTENERS/" "${CONFIGS_DIR}"/schema-registry.properties
  sed -i -e "s/KAFKASTORE_BOOTSTRAP_SERVERS/$KAFKASTORE_BOOTSTRAP_SERVERS/" "${CONFIGS_DIR}"/schema-registry.properties
  sed -i -e "s/KAFKASTORE_TOPIC/$KAFKASTORE_TOPIC/" "${CONFIGS_DIR}"/schema-registry.properties
  sed -i -e "s/DEBUG/$DEBUG/" "${CONFIGS_DIR}"/schema-registry.properties

  "$CONFLUENT_HOME"/bin/schema-registry-start -daemon $CONFIGS_DIR/schema-registry.properties
  echo "Started Schema Registry Service..."
  sleep 10
  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/schema-registry.log
}

start_kafka_connect() {
  echo "Starting Kafka Connect..."

  # KAFKA CONNECT PROPERTIES
  if [ "$CONNECT_WITH_AVRO_DISTRIBUTED" = "true" ]; then
    echo "Starting Kafka Connect with Avro Distributed Properties..."
    sed -i -e "s/BOOTSTRAP_SERVERS/$BOOTSTRAP_SERVERS/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/GROUP_ID/$GROUP_ID/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/KEY_CONVERTER_SCHEMAS_ENABLE/$KEY_CONVERTER_SCHEMAS_ENABLE/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/VALUE_CONVERTER_SCHEMAS_ENABLE/$VALUE_CONVERTER_SCHEMAS_ENABLE/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/KEY_CONVERTER_SCHEMA_REGISTRY_URL/$KEY_CONVERTER_SCHEMA_REGISTRY_URL/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/VALUE_CONVERTER_SCHEMA_REGISTRY_URL/$VALUE_CONVERTER_SCHEMA_REGISTRY_URL/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/KEY_CONVERTER/$KEY_CONVERTER/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/VALUE_CONVERTER/$VALUE_CONVERTER/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/OFFSET_STORAGE_TOPIC/$OFFSET_STORAGE_TOPIC/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/OFFSET_STORAGE_REPLICATION_FACTOR/$OFFSET_STORAGE_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/OFFSET_STORAGE_PARTITIONS/$OFFSET_STORAGE_PARTITIONS/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/CONFIG_STORAGE_TOPIC/$CONFIG_STORAGE_TOPIC/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/CONFIG_STORAGE_REPLICATION_FACTOR/$CONFIG_STORAGE_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/STATUS_STORAGE_TOPIC/$STATUS_STORAGE_TOPIC/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/STATUS_STORAGE_REPLICATION_FACTOR/$STATUS_STORAGE_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/STATUS_STORAGE_PARTITIONS/$STATUS_STORAGE_PARTITIONS/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/OFFSET_FLUSH_INTERVAL_MS/$OFFSET_FLUSH_INTERVAL_MS/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/CONNECT_REST_HOST/$CONNECT_REST_HOST/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/CONNECT_REST_PORT/$CONNECT_REST_PORT/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/CONNECT_REST_ADVERTISED_HOST/$CONNECT_REST_ADVERTISED_HOST/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/CONNECT_REST_ADVERTISED_PORT/$CONNECT_REST_ADVERTISED_PORT/" "${CONFIGS_DIR}"/connect-avro-distributed.properties
    sed -i -e "s/PLUGIN_PATH/$PLUGIN_PATH/" "${CONFIGS_DIR}"/connect-avro-distributed.properties

    "$CONFLUENT_HOME"/bin/connect-distributed -daemon $CONFIGS_DIR/connect-avro-distributed.properties
  else
    echo "Starting Kafka Connect with DEFAULT Distributed Properties..."
    sed -i -e "s/BOOTSTRAP_SERVERS/$BOOTSTRAP_SERVERS/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/GROUP_ID/$GROUP_ID/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/KEY_CONVERTER_SCHEMAS_ENABLE/$KEY_CONVERTER_SCHEMAS_ENABLE/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/VALUE_CONVERTER_SCHEMAS_ENABLE/$VALUE_CONVERTER_SCHEMAS_ENABLE/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/KEY_CONVERTER/$KEY_CONVERTER/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/VALUE_CONVERTER/$VALUE_CONVERTER/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/OFFSET_STORAGE_TOPIC/$OFFSET_STORAGE_TOPIC/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/OFFSET_STORAGE_REPLICATION_FACTOR/$OFFSET_STORAGE_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/OFFSET_STORAGE_PARTITIONS/$OFFSET_STORAGE_PARTITIONS/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/CONFIG_STORAGE_TOPIC/$CONFIG_STORAGE_TOPIC/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/CONFIG_STORAGE_REPLICATION_FACTOR/$CONFIG_STORAGE_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/STATUS_STORAGE_TOPIC/$STATUS_STORAGE_TOPIC/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/STATUS_STORAGE_REPLICATION_FACTOR/$STATUS_STORAGE_REPLICATION_FACTOR/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/STATUS_STORAGE_PARTITIONS/$STATUS_STORAGE_PARTITIONS/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/OFFSET_FLUSH_INTERVAL_MS/$OFFSET_FLUSH_INTERVAL_MS/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/CONNECT_REST_HOST/$CONNECT_REST_HOST/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/CONNECT_REST_PORT/$CONNECT_REST_PORT/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/CONNECT_REST_ADVERTISED_HOST/$CONNECT_REST_ADVERTISED_HOST/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/CONNECT_REST_ADVERTISED_PORT/$CONNECT_REST_ADVERTISED_PORT/" "${CONFIGS_DIR}"/connect-distributed.properties
    sed -i -e "s/PLUGIN_PATH/$PLUGIN_PATH/" "${CONFIGS_DIR}"/connect-distributed.properties

    "$CONFLUENT_HOME"/bin/connect-distributed.sh -daemon $CONFIGS_DIR/connect-distributed.properties
  fi

  echo "Started Kafka Connect Service..."
  sleep 10
  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/connect.log
}

start_ksql_db() {
  echo "Starting KSQL_DB Service..."

  # KSQL DB PROPERTIES
  sed -i -e "s/KSQL_DB_LISTENERS/$KSQL_DB_LISTENERS/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/BOOTSTRAP_SERVERS/$BOOTSTRAP_SERVERS/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE/$KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE/$KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_LOGGING_PROCESSING_ROWS_INCLUDE/$KSQL_LOGGING_PROCESSING_ROWS_INCLUDE/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_SCHEMA_REGISTRY_URL/$KSQL_SCHEMA_REGISTRY_URL/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/UI_ENABLED/$UI_ENABLED/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_STREAMS_AUTO_OFFSET_RESET/$KSQL_STREAMS_AUTO_OFFSET_RESET/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_STREAMS_COMMIT_INTERVAL_MS/$KSQL_STREAMS_COMMIT_INTERVAL_MS/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_STREAMS_CACHE_MAX_BYTES_BUFFERING/$KSQL_STREAMS_CACHE_MAX_BYTES_BUFFERING/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_FAIL_ON_DESERIALIZATION_ERROR/$KSQL_FAIL_ON_DESERIALIZATION_ERROR/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_STREAMS_NUM_STREAM_THREADS/$KSQL_STREAMS_NUM_STREAM_THREADS/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_SERVICE_ID/$KSQL_SERVICE_ID/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_SINK_PARTITIONS/$KSQL_SINK_PARTITIONS/" "${CONFIGS_DIR}"/ksql-server.properties
  sed -i -e "s/KSQL_SINK_REPLICAS/$KSQL_SINK_REPLICAS/" "${CONFIGS_DIR}"/ksql-server.properties

  "$CONFLUENT_HOME"/bin/ksql-server-start -daemon $CONFIGS_DIR/ksql-server.properties
  echo "Started Schema Registry Service..."
  sleep 10
  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/ksql.out
}

start_all() {
  start_zookeeper
  start_kafka_broker
  start_schema_registry
  start_kafka_connect
  start_ksql_db
  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/server.log
}

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"

case "${SERVICE_TYPE,,}" in
  "sh" )
    echo "Starting all the Confluent Kafka Services"
    start_all
  ;;

  "zookeeper" )
    echo "Starting the Zookeeper Service..."
    start_zookeeper
  ;;

  "kafka" )
    echo "Starting the Kafka Service..."
    start_kafka_broker
  ;;

  "schemaregistry" )
    echo "Starting the Schema Registry Service..."
    start_schema_registry
  ;;

  "connect" )
    echo "Starting the Kafka Connect Service"
    start_kafka_connect
  ;;

  "ksql" )
    echo "Starting the KSQL DB Service"
    start_ksql_db
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac

tail -f "$LOG_FILE_PATH"