#!/bin/sh
#set -e

echo "Starting Kibana on host - ${KIBANA_SERVER_NAME}:${KIBANA_SERVER_PORT}"

"$KIBANA_HOME"/bin/kibana