#!/bin/sh
#set -e

HBASE_CONF_FILE="$HBASE_CONF_DIR"/hbase-site.xml

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ standalone | distributed ]"
	echo "Stopping execution!"
	exit 1
}

SERVICE_TYPE=$1
HBASE_SERVICE=$2
echo "Input Service Type - ${SERVICE_TYPE}"
echo "Service - ${HBASE_SERVICE}"

LOG_FILE_PATH=""
LOG_FILE_PREFIX="$HBASE_HOME"/logs/hbase--

configure_properties() {
  # SETTING UP HBASE SERVICES PROPERTIES
  sed -i -e "s/HBASE_ROOT_DIR/$HBASE_ROOT_DIR/" "$HBASE_CONF_FILE"
  sed -i -e "s/HBASE_CLUSTER_DISTRIBUTED/$HBASE_CLUSTER_DISTRIBUTED/" "$HBASE_CONF_FILE"
  sed -i -e "s/ZOOKEEPER_QUORUM/$ZOOKEEPER_QUORUM/" "$HBASE_CONF_FILE"
}

start_standalone_hbase() {
  echo "Starting HBase locally..."
  export HBASE_CONF_DIR=$HBASE_HOME/conf
  "$HBASE_HOME"/bin/start-hbase.sh
  LOG_FILE_PATH="${LOG_FILE_PREFIX}master-${HOSTNAME}.log"
}

start_distributed_hbase() {
  echo "Waiting for 1 minute for Hadoop Services up and running"
  sleep 60
  echo "Starting HBase in distributed mode."
  case "${HBASE_SERVICE}" in
    "master" )
      echo "Starting HBase Master..."
      "$HBASE_HOME"/bin/hbase-daemon.sh --config "$HBASE_CONF_DIR" start master
      LOG_FILE_PATH="${LOG_FILE_PREFIX}master-${HOSTNAME}.log"
    ;;

    "regionserver" )
      echo "Starting HBase Region Server..."
      "$HBASE_HOME"/bin/hbase-daemon.sh --config "$HBASE_CONF_DIR" start regionserver
      LOG_FILE_PATH="${LOG_FILE_PREFIX}regionserver-${HOSTNAME}.log"
    ;;

    "all" )
      echo "Starting HBase Master..."
      "$HBASE_HOME"/bin/hbase-daemon.sh --config "$HBASE_CONF_DIR" start master
      sleep 10
      echo "Starting HBase Region Server"
      "$HBASE_HOME"/bin/hbase-daemon.sh --config "$HBASE_CONF_DIR" start regionserver
      LOG_FILE_PATH="${LOG_FILE_PREFIX}master-${HOSTNAME}.log"
      ;;
    * )
      "$HBASE_HOME"/bin/hbase-daemon.sh
      exit 1
    ;;
  esac
}

case "${SERVICE_TYPE,,}" in
  "sh" | "standalone")
    start_standalone_hbase
  ;;

  "distributed" )
    configure_properties
    start_distributed_hbase
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;
esac

sleep 10
tail -f "$LOG_FILE_PATH"