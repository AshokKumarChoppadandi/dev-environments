#!/bin/sh
#set -e

CONFIG_DIR="/usr/local/configs"
CONFIG_FILE="$CONFIG_DIR/zoo.cfg"

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [standalone / replicated]"
	echo "Stopping execution!"
	exit 1
}

LOG_FILE_PATH="$ZOOKEEPER_HOME/logs/zookeeper--server-$HOSTNAME.out"

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"

configure_properties() {
    echo "Configuring Zookeeper Properties..."

    # ZOOKEEPER PROPERTIES
    sed -i -e "s/TICK_TIME/$TICK_TIME/" "$CONFIG_FILE"
    sed -i -e "s/INIT_LIMIT/$INIT_LIMIT/" "$CONFIG_FILE"
    sed -i -e "s/SYNC_LIMIT/$SYNC_LIMIT/" "$CONFIG_FILE"
    sed -i -e "s/DATA_DIR/$DATA_DIR/" "$CONFIG_FILE"
    sed -i -e "s/CLIENT_PORT/$CLIENT_PORT/" "$CONFIG_FILE"
    sed -i -e "s/MAX_CLIENT_CONNECTIONS/$MAX_CLIENT_CONNECTIONS/" "$CONFIG_FILE"
    sed -i -e "s/METRICS_PROVIDER_HTTP_PORT/$METRICS_PROVIDER_HTTP_PORT/" "$CONFIG_FILE"
    sed -i -e "s/METRICS_PROVIDER_EXPORT_JVM_INFO/$METRICS_PROVIDER_EXPORT_JVM_INFO/" "$CONFIG_FILE"
}

configure_replicated_properties() {
  echo "Configuring Replicated Properties"

  ZOOKEEPER_SERVERS=(${QUORUM//,/ })
  SERVER_NUMBER=1
  for SERVER in "${ZOOKEEPER_SERVERS[@]}"; do
    echo "server.$SERVER_NUMBER=$SERVER:2888:3888" >> "$CONFIG_FILE"
    SERVER_NUMBER=$((SERVER_NUMBER+1))
  done
}

start_zookeeper() {
  configure_properties
  TMP=$(echo "$DATA_DIR" | sed -r 's/\\//g')
  mkdir "$TMP"

  if [ "$SERVICE_TYPE" = "replicated" ]; then
    configure_replicated_properties
    echo "$ZOOKEEPER_ID" > "$TMP"/myid
  fi
  echo "Starting Zookeeper..."
  "$ZOOKEEPER_HOME"/bin/zkServer.sh --config "$CONFIG_DIR" start
}

case "${SERVICE_TYPE,,}" in
  "sh" | "standalone" | "replicated")
    start_zookeeper
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;
esac

tail -f "$LOG_FILE_PATH"