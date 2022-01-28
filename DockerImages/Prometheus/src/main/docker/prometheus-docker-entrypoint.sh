#!/bin/sh
#set -e

if [ -z "$PROMETHEUS_CONFIG_FILE" ]; then
  echo "No config file is passed for Prometheus using the default config file."
  PROMETHEUS_CONFIG_FILE=$PROMETHEUS_DEFAULT_CONFIG_FILE
fi

echo "Prometheus config file path : ${PROMETHEUS_CONFIG_FILE} & data directory : ${PROMETHEUS_DATA_DIR}"
echo "Starting Prometheus on Host : ${PROMETHEUS_HOST} at PORT : ${PROMETHEUS_PORT}..."

"$PROMETHEUS_HOME"/prometheus --config.file="$PROMETHEUS_CONFIG_FILE" --storage.tsdb.path="$PROMETHEUS_DATA_DIR" --web.external-url=http://"$PROMETHEUS_HOST":"$PROMETHEUS_PORT"

