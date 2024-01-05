#!/bin/sh
#set -e

HOSTNAME=$(hostname)

case "$HOSTNAME" in
"namenode")
  echo "Checking Namenode Status..."
  curl --fail http://"$HOSTNAME":50070/ || exit 1
  ;;

"secondarynamenode")
  echo "Checking Secondary Namenode Status..."
  curl --fail http://"$HOSTNAME":50090/ || exit 1
  ;;

"resourcemanager")
  echo "Checking Resource Manager Status..."
  curl --fail http://"$HOSTNAME":8088/ || exit 1
  ;;

"historyserver")
  echo "Checking MR History Server Status..."
  curl --fail http://"$HOSTNAME":19888/ || exit 1
  ;;

"slavenode" | "slavenode1" | "slavenode2" | "slavenode3")
  echo "Checking Slave Node Status..."
  curl --fail http://"$HOSTNAME":8042/ && (hdfs dfs -put -f health_check.sh) || exit 1
  ;;

*)
  echo "Checking all services statuses..."
  curl --fail http://"$HOSTNAME":50070/ \
    && curl --fail http://"$HOSTNAME":50090/ \
    && curl --fail http://"$HOSTNAME":8088/ \
    && curl --fail http://"$HOSTNAME":19888/ \
    && curl --fail http://"$HOSTNAME":8042/ \
    && hdfs dfs -put -f health_check.sh \
    || exit 1
  ;;
esac