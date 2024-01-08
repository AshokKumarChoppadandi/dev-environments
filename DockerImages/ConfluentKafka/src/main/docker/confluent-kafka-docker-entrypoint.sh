#!/bin/sh
#set -e

CONFIGS_DIR="/usr/local/configs"
ZOOKEEPER_PROPERTIES="${CONFIGS_DIR}/zookeeper.properties"
KAFKA_SERVER_PROPERTIES="${CONFIGS_DIR}/server.properties"
SCHEMA_REGISTRY_PROPERTIES="${CONFIGS_DIR}/schema-registry.properties"
KAFKA_CONNECT_PROPERTIES="${CONFIGS_DIR}/connect-distributed.properties"

if [ "$CONNECT_WITH_AVRO_DISTRIBUTED" = "true" ]; then
  KAFKA_CONNECT_PROPERTIES="${CONFIGS_DIR}/connect-avro-distributed.properties"
fi

KSQL_SERVER_PROPERTIES="${CONFIGS_DIR}/ksql-server.properties"


# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ zookeeper | kafka | connect | schemaregistry | ksqldb ]"
	echo "Stopping execution!"
	exit 1
}

# DEFINING A USAGE FUNCTION
zookeeper_usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ zookeeper] [standalone / replicated]"
	echo "Stopping execution!"
	exit 1
}

LOG_FILE_PATH="$CONFLUENT_HOME"/logs/server.log

SERVICE_TYPE=$1
ZOOKEEPER_SERVICE_TYPE=$2
echo "Input Service Type 1 - ${SERVICE_TYPE}"
echo "Input Service Type 2 - ${ZOOKEEPER_SERVICE_TYPE}"

configure_zookeeper_replicated_properties() {
  echo "Configuring Zookeeper Replicated Properties"

  ZOOKEEPER_SERVERS=(${ZOOKEEPER_QUORUM//,/ })
  SERVER_NUMBER=1
  for SERVER in "${ZOOKEEPER_SERVERS[@]}"; do
    echo "server.$SERVER_NUMBER=$SERVER:2888:3888" >> "${ZOOKEEPER_PROPERTIES}"
    SERVER_NUMBER=$((SERVER_NUMBER+1))
  done
}

start_zookeeper() {
  case "${ZOOKEEPER_SERVICE_TYPE,,}" in
    "sh" | "standalone" | "replicated" )
      echo "Started configuring Zookeeper properties..."
    ;;

    * )
      zookeeper_usage "${ZOOKEEPER_SERVICE_TYPE,,}"
    ;;
  esac

  # ZOOKEEPER PROPERTIES
  sed -i -e "s|ZOOKEEPER_DATA_DIR|$ZOOKEEPER_DATA_DIR|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_CLIENT_PORT|$ZOOKEEPER_CLIENT_PORT|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_MAX_CLIENT_CONNECTIONS|$ZOOKEEPER_MAX_CLIENT_CONNECTIONS|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_TICK_TIME|$ZOOKEEPER_TICK_TIME|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_INIT_LIMIT|$ZOOKEEPER_INIT_LIMIT|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_SYNC_LIMIT|$ZOOKEEPER_SYNC_LIMIT|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_ENABLE_SERVER|$ZOOKEEPER_ENABLE_SERVER|g" "${ZOOKEEPER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_ADMIN_SERVER_PORT|$ZOOKEEPER_ADMIN_SERVER_PORT|g" "${ZOOKEEPER_PROPERTIES}"

  mkdir "$ZOOKEEPER_DATA_DIR"

  if [ "$ZOOKEEPER_SERVICE_TYPE" = "replicated" ]; then
    configure_zookeeper_replicated_properties
    echo "$ZOOKEEPER_ID" > "$ZOOKEEPER_DATA_DIR"/myid
  fi

  "$CONFLUENT_HOME"/bin/zookeeper-server-start -daemon "${ZOOKEEPER_PROPERTIES}"
  echo "Started Zookeeper Service..."

  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/zookeeper.out
}

start_kafka_broker() {
  echo "Starting Kafka Broker..."

  # KAFKA BROKER / SERVER PROPERTIES
  sed -i -e "s|BROKER_ID|$BROKER_ID|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|KAFKA_LISTENERS|$KAFKA_LISTENERS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|KAFKA_ADVERTISED_LISTENERS|$KAFKA_ADVERTISED_LISTENERS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|KAFKA_LISTENER_SECURITY_PROTOCOL_MAP|$KAFKA_LISTENER_SECURITY_PROTOCOL_MAP|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|KAFKA_INTER_BROKER_LISTENER_NAME|$KAFKA_INTER_BROKER_LISTENER_NAME|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|NUM_NETWORK_THREADS|$NUM_NETWORK_THREADS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|NUM_IO_THREADS|$NUM_IO_THREADS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|SOCKET_SEND_BUFFER_BYTES|$SOCKET_SEND_BUFFER_BYTES|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|SOCKET_RECEIVE_BUFFER_BYTES|$SOCKET_RECEIVE_BUFFER_BYTES|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|SOCKET_REQUEST_MAX_BYTES|$SOCKET_REQUEST_MAX_BYTES|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|LOG_DIRS|$LOG_DIRS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|NUM_PARTITIONS|$NUM_PARTITIONS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|NUM_RECOVERY_THREADS_PER_DATA_DIR|$NUM_RECOVERY_THREADS_PER_DATA_DIR|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|OFFSETS_TOPIC_REPLICATION_FACTOR|$OFFSETS_TOPIC_REPLICATION_FACTOR|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|TRANSACTION_STATE_LOG_REPLICATION_FACTOR|$TRANSACTION_STATE_LOG_REPLICATION_FACTOR|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|TRANSACTION_STATE_LOG_MIN_ISR|$TRANSACTION_STATE_LOG_MIN_ISR|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|LOG_RETENTION_HOURS|$LOG_RETENTION_HOURS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|LOG_SEGMENT_BYTES|$LOG_SEGMENT_BYTES|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|LOG_RETENTION_CHECK_INTERVAL_MS|$LOG_RETENTION_CHECK_INTERVAL_MS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_CONNECT_LIST|$ZOOKEEPER_CONNECT_LIST|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|ZOOKEEPER_CONNECTION_TIMEOUT_MS|$ZOOKEEPER_CONNECTION_TIMEOUT_MS|g" "${KAFKA_SERVER_PROPERTIES}"
  sed -i -e "s|GROUP_INITIAL_REBALANCE_DELAY_MS|$GROUP_INITIAL_REBALANCE_DELAY_MS|g" "${KAFKA_SERVER_PROPERTIES}"

  "$CONFLUENT_HOME"/bin/kafka-server-start -daemon "${KAFKA_SERVER_PROPERTIES}"
  echo "Started kafka Service..."

  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/server.log
}

start_schema_registry() {
  echo "Starting Schema Registry Service..."

  # SCHEMA REGISTRY PROPERTIES
  sed -i -e "s|SCHEMA_REGISTRY_LISTENERS|$SCHEMA_REGISTRY_LISTENERS|g" "${SCHEMA_REGISTRY_PROPERTIES}"
  sed -i -e "s|KAFKASTORE_BOOTSTRAP_SERVERS|$KAFKASTORE_BOOTSTRAP_SERVERS|g" "${SCHEMA_REGISTRY_PROPERTIES}"
  sed -i -e "s|KAFKASTORE_TOPIC|$KAFKASTORE_TOPIC|g" "${SCHEMA_REGISTRY_PROPERTIES}"
  sed -i -e "s|DEBUG|$DEBUG|g" "${SCHEMA_REGISTRY_PROPERTIES}"

  "$CONFLUENT_HOME"/bin/schema-registry-start -daemon "${SCHEMA_REGISTRY_PROPERTIES}"
  echo "Started Schema Registry Service..."

  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/schema-registry.log
}

start_kafka_connect() {
  echo "Starting Kafka Connect Service..."

  sed -i -e "s|BOOTSTRAP_SERVERS|$BOOTSTRAP_SERVERS|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|GROUP_ID|$GROUP_ID|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|KEY_CONVERTER_SCHEMAS_ENABLE|$KEY_CONVERTER_SCHEMAS_ENABLE|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|VALUE_CONVERTER_SCHEMAS_ENABLE|$VALUE_CONVERTER_SCHEMAS_ENABLE|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|KEY_CONVERTER|$KEY_CONVERTER|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|VALUE_CONVERTER|$VALUE_CONVERTER|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|OFFSET_STORAGE_TOPIC|$OFFSET_STORAGE_TOPIC|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|OFFSET_STORAGE_REPLICATION_FACTOR|$OFFSET_STORAGE_REPLICATION_FACTOR|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|OFFSET_STORAGE_PARTITIONS|$OFFSET_STORAGE_PARTITIONS|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|CONFIG_STORAGE_TOPIC|$CONFIG_STORAGE_TOPIC|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|CONFIG_STORAGE_REPLICATION_FACTOR|$CONFIG_STORAGE_REPLICATION_FACTOR|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|STATUS_STORAGE_TOPIC|$STATUS_STORAGE_TOPIC|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|STATUS_STORAGE_REPLICATION_FACTOR|$STATUS_STORAGE_REPLICATION_FACTOR|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|STATUS_STORAGE_PARTITIONS|$STATUS_STORAGE_PARTITIONS|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|OFFSET_FLUSH_INTERVAL_MS|$OFFSET_FLUSH_INTERVAL_MS|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|CONNECT_REST_HOST|$CONNECT_REST_HOST|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|CONNECT_REST_PORT|$CONNECT_REST_PORT|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|CONNECT_REST_ADVERTISED_HOST|$CONNECT_REST_ADVERTISED_HOST|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|CONNECT_REST_ADVERTISED_PORT|$CONNECT_REST_ADVERTISED_PORT|g" "${KAFKA_CONNECT_PROPERTIES}"
  sed -i -e "s|PLUGIN_PATH|$PLUGIN_PATH|g" "${KAFKA_CONNECT_PROPERTIES}"

  # KAFKA CONNECT PROPERTIES
  if [ "$CONNECT_WITH_AVRO_DISTRIBUTED" = "true" ]; then
    echo "Starting Kafka Connect with Avro Distributed Properties..."
    sed -i -e "s|KEY_CONVERTER_SCHEMA_REGISTRY_URL|$KEY_CONVERTER_SCHEMA_REGISTRY_URL|g" "${KAFKA_CONNECT_PROPERTIES}"
    sed -i -e "s|VALUE_CONVERTER_SCHEMA_REGISTRY_URL|$VALUE_CONVERTER_SCHEMA_REGISTRY_URL|g" "${KAFKA_CONNECT_PROPERTIES}"
  fi

  "$CONFLUENT_HOME"/bin/connect-distributed -daemon "${KAFKA_CONNECT_PROPERTIES}"
  echo "Started Kafka Connect Service..."

  LOG_FILE_PATH="$CONFLUENT_HOME"/logs/connect.log
}

start_ksql_db() {
  echo "Starting KSQL_DB Service..."

  # KSQL DB PROPERTIES
  sed -i -e "s|KSQL_DB_LISTENERS|$KSQL_DB_LISTENERS|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|BOOTSTRAP_SERVERS|$BOOTSTRAP_SERVERS|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE|$KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE|$KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_LOGGING_PROCESSING_ROWS_INCLUDE|$KSQL_LOGGING_PROCESSING_ROWS_INCLUDE|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_SCHEMA_REGISTRY_URL|$KSQL_SCHEMA_REGISTRY_URL|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|UI_ENABLED|$UI_ENABLED|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_STREAMS_AUTO_OFFSET_RESET|$KSQL_STREAMS_AUTO_OFFSET_RESET|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_STREAMS_COMMIT_INTERVAL_MS|$KSQL_STREAMS_COMMIT_INTERVAL_MS|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_STREAMS_CACHE_MAX_BYTES_BUFFERING|$KSQL_STREAMS_CACHE_MAX_BYTES_BUFFERING|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_FAIL_ON_DESERIALIZATION_ERROR|$KSQL_FAIL_ON_DESERIALIZATION_ERROR|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_STREAMS_NUM_STREAM_THREADS|$KSQL_STREAMS_NUM_STREAM_THREADS|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_SERVICE_ID|$KSQL_SERVICE_ID|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_SINK_PARTITIONS|$KSQL_SINK_PARTITIONS|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_SINK_REPLICAS|$KSQL_SINK_REPLICAS|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_KSQL_EXTENSION_DIR|$KSQL_KSQL_EXTENSION_DIR|g" "${KSQL_SERVER_PROPERTIES}"
  sed -i -e "s|KSQL_KSQL_CONNECT_URL|$KSQL_KSQL_CONNECT_URL|g" "${KSQL_SERVER_PROPERTIES}"

  "$CONFLUENT_HOME"/bin/ksql-server-start -daemon "${KSQL_SERVER_PROPERTIES}"
  echo "Started KSQL Server Service..."

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

until [ -f "$LOG_FILE_PATH" ]
do
  sleep 5
done

tail -f "$LOG_FILE_PATH"