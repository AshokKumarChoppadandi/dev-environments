#!/bin/sh
#set -e

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [default / custom]"
	echo "Stopping execution!"
	exit 1
}

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"

# CONFIG_FILE=""
#
# case "${SERVICE_TYPE,,}" in
#   "sh" | "default" )
#     CONFIG_FILE=$GRAFANA_HOME/conf/defaults.ini
#     echo "Starting Grafana with default config file - ${CONFIG_FILE}"
#   ;;
#
#   "custom" )
#     CONFIG_FILE=$GRAFANA_HOME/conf/custom.ini
#     echo "Starting Grafana with custom config file - ${CONFIG_FILE}"
#   ;;
#
#   * )
#     usage "${SERVICE_TYPE,,}"
#   ;;
#
# esac


CONFIG_FILE=$GRAFANA_HOME/conf/custom.ini
echo "Starting Grafana on ${HOSTNAME}:${HTTP_PORT}"

sleep 15

"$GRAFANA_HOME"/bin/grafana-server \
  --config="$CONFIG_FILE" \
  --homepath "$GRAFANA_HOME" \
  cfg:default.paths.logs="$GRAFANA_HOME" \
  cfg:default.paths.data="$GRAFANA_HOME" \
  cfg:default.paths.plugins="$GRAFANA_HOME"/plugins-bundled
