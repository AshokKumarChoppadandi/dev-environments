#!/bin/sh
#set -e

echo "Starting Elasticsearch on host - ${ES_NODE_NAME}:${ES_HTTP_PORT}"

"$ES_HOME"/bin/elasticsearch