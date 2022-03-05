#!/bin/sh
#set -e

usage() {
  	echo "Invalid Argument - $1"
  	echo "Usage: $0 [USER] [COMMA SEPARATED SERVERS LIST]"
  	echo "Stopping execution!"
  	exit 1
}

echo "Shutting down all the Servers / VMs"

ARGS=$1
USER=$2

if [ -z "$ARGS" ]; then
  echo "No Arguments provided!!!"
  # usage "$@"
  ARGS="dockermachine1,worker3,worker2,worker1,master3,master2,master1"
  echo "Servers list - $ARGS"
fi

if [ -z "$USER" ]; then
  echo "No USER provided! Continuing with default user - bigdata"
  USER="bigdata"
fi

COMMAND=""
SERVER_LIST=(${ARGS//,/ })
for SERVER in "${SERVER_LIST[@]}"; do
  echo "$USER user shutting down host - ${SERVER}.bigdata.com"
  COMMAND="ssh -t $USER@$SERVER.bigdata.com 'sudo poweroff'"
  echo "$COMMAND"
  echo "Sleeping for 10 seconds"
  sleep 10
done

THIS_HOST="$(hostname -f)"

echo "Do you want to shutdown this machine - ${THIS_HOST} ??? Press y/N :"
while read shutdownFlag
do
  case "${shutdownFlag,,}" in
    "y" | "yes" )
      echo "$USER user shutting down the host server - ${THIS_HOST}"
      COMMAND="sudo poweroff"
      echo "$COMMAND"
      break
    ;;
    "n" | "no" )
      echo "Stopping the shutdown script!!!"
      break
    ;;
    * )
      echo "Do you want to shutdown this machine - ${THIS_HOST} ??? Press y/N :"
      continue
    ;;
  esac
done < /dev/stdin
