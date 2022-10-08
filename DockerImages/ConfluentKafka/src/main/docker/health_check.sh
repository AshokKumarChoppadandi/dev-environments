#!/bin/sh
#set -e

HOSTNAME=$(hostname)

case "$HOSTNAME" in
"zookeeper" | "zookeeper1" | "zookeeper2" | "zookeeper3")
  echo "Checking Zookeeper Status..."
  echo ruok | nc "$HOSTNAME" 2181 || exit 1
  ;;
"broker" | "broker1" | "broker2" | "broker3")
  echo "Checking Kafka Broker Status..."
  nc -z "$HOSTNAME" 9092 || exit 1
  ;;
"schemaregistry")
  echo "Checking schemaregistry Status..."
  curl --fail http://"$HOSTNAME":8081 || exit 1
  ;;
"connect")
  echo "Checking schemaregistry Status..."
  curl --fail http://"$HOSTNAME":8083/ || exit 1
  ;;
"ksql")
  echo "Checking schemaregistry Status..."
  curl --fail http://"$HOSTNAME":8088/ || exit 1
  ;;
*)
  echo "Checking all services statuses..."
  echo ruok | nc "$HOSTNAME" 2181 \
    && nc -z "$HOSTNAME" 9092 \
    && curl --fail http://"$HOSTNAME":8081/ \
    && curl --fail http://"$HOSTNAME":8083/ \
    && curl --fail http://"$HOSTNAME":8088/ \
    || exit 1
  ;;
esac