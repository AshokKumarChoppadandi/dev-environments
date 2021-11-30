#!/bin/sh
#set -e

CONFIGS_DIR="/usr/local/configs"

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [zookeeper / kafka / connect]"
	echo "Stopping execution!"
	exit 1
}

LOG_FILE_PATH="$KAFKA_HOME"/logs/server.log

start_zookeeper() {
  echo "Starting Zookeeper..."

  # ZOOKEEPER PROPERTIES
  sed -i -e "s/ZOOKEEPER_DATA_DIR/$ZOOKEEPER_DATA_DIR/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_CLIENT_PORT/$ZOOKEEPER_CLIENT_PORT/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_MAX_CLIENT_CONNECTIONS/$ZOOKEEPER_MAX_CLIENT_CONNECTIONS/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_ENABLE_SERVER/$ZOOKEEPER_ENABLE_SERVER/" "${CONFIGS_DIR}"/zookeeper.properties
  sed -i -e "s/ZOOKEEPER_ADMIN_SERVER_PORT/$ZOOKEEPER_ADMIN_SERVER_PORT/" "${CONFIGS_DIR}"/zookeeper.properties

  "$KAFKA_HOME"/bin/zookeeper-server-start.sh -daemon $CONFIGS_DIR/zookeeper.properties
  echo "Started Zookeeper Service..."
  sleep 10
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
  sed -i -e "s/DEFAULT_PARTITIONS/$DEFAULT_PARTITIONS/" "${CONFIGS_DIR}"/server.properties
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

  "$KAFKA_HOME"/bin/kafka-server-start.sh -daemon $CONFIGS_DIR/server.properties
  echo "Started kafka Service..."
  sleep 10
}

start_kafka_connect() {
  echo "Starting Kafka Connect..."

  # KAFKA CONNECT PROPERTIES
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
  sed -i -e "s/CONNECT_HOST/$CONNECT_HOST/" "${CONFIGS_DIR}"/connect-distributed.properties
  sed -i -e "s/CONNECT_PORT/$CONNECT_PORT/" "${CONFIGS_DIR}"/connect-distributed.properties
  sed -i -e "s/CONNECT_REST_ADVERTISED_HOST/$CONNECT_REST_ADVERTISED_HOST/" "${CONFIGS_DIR}"/connect-distributed.properties
  sed -i -e "s/CONNECT_REST_ADVERTISED_PORT/$CONNECT_REST_ADVERTISED_PORT/" "${CONFIGS_DIR}"/connect-distributed.properties
  sed -i -e "s/PLUGIN_PATH/$PLUGIN_PATH/" "${CONFIGS_DIR}"/connect-distributed.properties

  "$KAFKA_HOME"/bin/connect-distributed.sh $CONFIGS_DIR/connect-distributed.properties &
  sleep 10

}

start_all() {
  start_zookeeper
  start_kafka_broker
  start_kafka_connect
}

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"

case "${SERVICE_TYPE,,}" in
  "sh" )
    echo "Starting all the Apache Kafka Services"
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

  "connect" )
    echo "Starting the Kafka Connect Service"
    start_kafka_connect
    LOG_FILE_PATH=$KAFKA_HOME/logs/connect.log
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac

tail -f "$LOG_FILE_PATH"