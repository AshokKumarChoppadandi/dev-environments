#!/bin/sh
#set -e

if [ -z "$ALERT_MANAGER_CONFIG_FILE" ]; then
  echo "No config file is passed for Alert Manager using the default config file."
  ALERT_MANAGER_CONFIG_FILE=$ALERT_MANAGER_DEFAULT_CONFIG_FILE
fi

echo "Alert Manager config file path : ${ALERT_MANAGER_CONFIG_FILE}"
echo "Starting Alert Manager on Host : ${ALERT_MANAGER_HOST} at PORT : ${ALERT_MANAGER_PORT}..."
"$ALERT_MANAGER_HOME"/alertmanager --config.file="$ALERT_MANAGER_CONFIG_FILE" --web.external-url=http://"$ALERT_MANAGER_HOST":"$ALERTMANAGER_PORT"

