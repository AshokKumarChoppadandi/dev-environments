#!/bin/sh
#set -e

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [standalone / cloud]"
	echo "Stopping execution!"
	exit 1
}

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"

case "${SERVICE_TYPE,,}" in
  "sh" | "standalone" )
    echo "Starting Solr locally..."
    "$SOLR_HOME"/bin/solr start -c -m "$MEMORY" -h "$HOSTNAME" -p "$SOLR_PORT" -d "$SOLR_HOME"/server -s "$SOLR_DATA_DIR"
  ;;

  "cloud" )
    echo "Waiting for Zookeeper Service up & running"
    sleep 10
    echo "Starting Solr in Cloud Mode..."
    "$SOLR_HOME"/bin/solr start -c -m "$MEMORY" -z "$ZOOKEEPER_QUORUM" -h "$HOSTNAME" -p "$SOLR_PORT" -d "$SOLR_HOME"/server -s "$SOLR_DATA_DIR"
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac

LOG_FILE_PATH="$SOLR_HOME/server/logs/solr.log"

tail -f "$LOG_FILE_PATH"
