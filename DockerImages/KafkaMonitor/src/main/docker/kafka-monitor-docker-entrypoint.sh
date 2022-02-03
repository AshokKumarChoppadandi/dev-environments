#!/bin/sh
#set -e

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ one | single | multi ]"
	echo "Stopping execution!"
	exit 1
}

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"


case "${SERVICE_TYPE,,}" in
  "sh" | "single" | "one" )
    if [[ -z "$KAFKA_MONITOR_TOPIC" || -z "$BROKER_LIST" || -z "$ZOOKEEPER_QUORUM" ]]; then
        echo "Invalid arguments..."
        echo "KAFKA_MONITOR_TOPIC - ${KAFKA_MONITOR_TOPIC}"
        echo "BROKER_LIST - ${BROKER_LIST}"
        echo "ZOOKEEPER_QUORUM - ${ZOOKEEPER_QUORUM}"
        usage
    fi
    echo "Starting Kafka Monitor for single cluster..."
    "${KAFKA_MONITOR_HOME_DIR}"/bin/single-cluster-monitor.sh --topic "${KAFKA_MONITOR_TOPIC}" --broker-list "${BROKER_LIST}" --zookeeper "${ZOOKEEPER_QUORUM}"

  ;;

  "namenode" )
    echo "Starting Namenode Service..."
    start_namenode
  ;;

  "secondarynamenode" )
    echo "Starting Secondary Namenode Service..."
    start_secondarynamenode
  ;;

  "resourcemanager" )
    echo "Starting Resource Manager Service..."
    start_resourcemanager
  ;;

  "historyserver" )
    echo "Starting History Server Service"
    start_historyserver
  ;;

  "slavenode" )
    echo "Starting Slave Node"
    select_and_start_slavenode
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac