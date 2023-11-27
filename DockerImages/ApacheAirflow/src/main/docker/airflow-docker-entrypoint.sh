#!/bin/sh
#set -e

# AIRFLOW_DEFAULT_CONFIG_FILE=/root/airflow/airflow.cfg

# if [ -z "$AIRFLOW_CONFIG_FILE" ]; then
#   echo "No config file is passed for Airflow using the default config file."
#   AIRFLOW_CONFIG_FILE=$AIRFLOW_DEFAULT_CONFIG_FILE
# fi

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ webserver | scheduler | sh ]"
	echo "Stopping execution!"
	exit 1
}

# echo "Airflow config file path : ${AIRFLOW_CONFIG_FILE}"

SERVICE_TYPE=$1

# echo "Sleeping for 30 seconds"
# sleep 30
# export AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="${SQL_ALCHEMY_CONN_PREFIX}://${AIRFLOW_DB_USER}:${AIRFLOW_DB_PASSWORD}@${AIRFLOW_DB_HOST}:${AIRFLOW_DB_PORT}/${AIRFLOW_DB_NAME}"
# echo "${AIRFLOW__DATABASE__SQL_ALCHEMY_CONN}"

case "${SERVICE_TYPE,,}" in
  "sh" )
    echo "Starting Shell"
    tail -f /dev/null
  ;;

  "webserver" )
    echo "$AIRFLOW__DATABASE__SQL_ALCHEMY_CONN"
    airflow db init
    sleep 5

    airflow users create --username admin --firstname ashok --lastname kumar  --role Admin --email ashok@test.com --password admin
    sleep 5

    echo "Starting Airflow Webserver on Host : ${AIRFLOW_HOST} at PORT : ${AIRFLOW_PORT}..."
    airflow webserver --port="${AIRFLOW_PORT}"
  ;;

  "scheduler" )
    echo "$AIRFLOW__DATABASE__SQL_ALCHEMY_CONN"
    echo "Starting Airflow Scheduler on Host : ${AIRFLOW_HOST}..."
    airflow scheduler
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac
