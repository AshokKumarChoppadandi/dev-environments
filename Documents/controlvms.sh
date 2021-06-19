#!/bin/bash

# Declaring the Services
HADOOP_VMS=("NameNode" "SecondaryNameNode" "DataNode" "ResourceManager" "NodeManager" "MRHistoryServer")
KAFKA_VMS=("Zookeeper1" "Zookeeper2" "Zookeeper3" "Broker1" "Broker2" "Broker3" "SchemaRegistry" "AdministrationMachine")
ADMINISTRATION_VMS=("AdministrationMachine" "AdministrationMachine2")
ELASTICSEARCH_VMS=("Elasticsearch1" "Elasticsearch2" "Elasticsearch3" "Kibana")
AIRFLOW_VMS=("AirflowWebUI" "AirflowScheduler")

# SERVICE VMS
SERVICE_VMS=""

# RUNNING VIRTUAL MACHINES
RUNNING_VMS=""

# DEFINING A USAGE FUNCTION
usage() {
	echo "Insufficient Mandatory Arguments..."
	echo "Usage: $0 [-s <VMs SERVICE TYPE>] [-a <ACTION TYPE>]"
	echo "Stopping execution!"
	exit 1
}

# GET ALL VIRTUAL MACHINES FOR A GIVEN SERVICE
get_service_vms() {
  SERVICE=$1

  case "${SERVICE}" in
  "hadoop") SERVICE_VMS=( "${HADOOP_VMS[@]}" )
    ;;
  "kafka") SERVICE_VMS=( "${KAFKA_VMS[@]}" )
    ;;
  "elasticsearch") SERVICE_VMS=( "${ELASTICSEARCH_VMS[@]}" )
    ;;
  "airflow") SERVICE_VMS=( "${AIRFLOW_VMS[@]}" )
    ;;
  "admin") SERVICE_VMS=( "${ADMINISTRATION_VMS[@]}" )
    ;;
  *) echo "UNKNOWN SERVICE_TYPE..."
    usage
    ;;
  esac
}

# PRINT ALL THE VIRTUAL MACHINES FOR A GIVEN SERVICE
print_vms() {
  VMS_LENGTH=${#SERVICE_VMS[@]}
  echo "VIRTUAL MACHINES"
  echo "----------------------"
  for (( i = 0; i < VMS_LENGTH; i++ )); do
      echo "${SERVICE_VMS[${i}]}"
  done
}

# PRINT THE STATUS OF ALL THE VIRTUAL MACHINES FOR A GIVEN SERVICE
print_vms_status() {
  RUNNING_VMS_TEMP=( "$@" )
  echo "RUNNING VIRTUAL MACHINES"
  echo "------------------------"
  for i in "${SERVICE_VMS[@]}"
   do
    VM=$(echo "$i" | sed -r 's/\"//g' | awk '{split($0, a, " "); print a[1]}')
    match=$(echo "${RUNNING_VMS_TEMP[@]}" | grep -o "$VM")
    if [ -n "$match" ]; then
        echo "$VM is running..."
    else
        echo "$VM is not running!"
    fi
  done
}

# GET THE LIST OF RUNNING VIRTUAL MACHINES FOR A GIVEN SERVICE
get_running_vms() {
  readarray -t array <<< "$(vboxmanage list runningvms)"
  RUNNING_VMS=( "${array[@]}" )
}

# PRINTS THE LIST OF RUNNING VIRTUAL MACHINES FOR A GIVEN SERVICE
list_running_vms() {
  get_running_vms
  print_vms_status "${RUNNING_VMS[@]}"
}

# STOP THE RUNNING VIRTUAL MACHINES FOR A GIVEN SERVICE
stop_running_vms() {
  echo "STOPPING VIRTUAL MACHINES"
  echo "-------------------------"

  get_running_vms

  for VM in "${SERVICE_VMS[@]}"
  do
    match=$(echo "${RUNNING_VMS[@]}" | grep -o "$VM")
    if [ -n "$match" ]; then
      echo "Stopping $VM ..."
      if vboxmanage controlvm "$VM" poweroff; then
        sleep 5
        echo "$VM stopped successfully..."
      else
        echo "Error while stopping $VM !!!"
      fi
    else
      echo "$VM is not running!"
    fi
  done
}

# START THE VIRTUAL MACHINES FOR A GIVEN SERVICE
start_vms() {
  echo "STARTING VIRTUAL MACHINES"
  echo "-------------------------"
  get_running_vms
  for VM in "${SERVICE_VMS[@]}"
  do
    match=$(echo "${RUNNING_VMS[@]}" | grep -o "$VM")
    if [ -z "$match" ]; then
      echo "Starting $VM ..."
      if vboxmanage startvm "$VM"; then
        sleep 15
        echo "$VM started successfully..."
      else
        echo "Error while starting $VM !!!"
      fi
    else
      echo "$VM already up and running!!!"
    fi
  done
}

# PAUSE ALL THE RUNNING VIRTUAL MACHINES FOR A GIVEN SERVICE
pause_running_vms() {
  echo "PAUSING VIRTUAL MACHINES"
  echo "-------------------------"
  get_running_vms
  for VM in "${SERVICE_VMS[@]}"
  do
    match=$(echo "${RUNNING_VMS[@]}" | grep -o "$VM")
    if [ -n "$match" ] && ! vboxmanage showvminfo "$VM" | grep "State" | grep -q "paused" && vboxmanage controlvm "$VM" pause; then
      sleep 15
      echo "$VM paused successfully..."
    else
      echo "$VM is already paused or not running!!!"
    fi
  done
}

# RESUME ALL THE PAUSED VIRTUAL MACHINES FOR A GIVEN SERVICE
resume_paused_vms() {
  echo "RESUMING VIRTUAL MACHINES"
  echo "-------------------------"
  get_running_vms
  for VM in "${SERVICE_VMS[@]}"
  do
    match=$(echo "${RUNNING_VMS[@]}" | grep -o "$VM")
    if [ -z "$match" ]; then
      echo "$VM is not running!"
    elif vboxmanage showvminfo "$VM" | grep "State" | grep -q "paused" && vboxmanage controlvm "$VM" resume; then
      sleep 15
      echo "$VM is resumed..."
    else
      echo "$VM might have resumed and already running!"
    fi
  done
}

# EXECUTING THE GIVEN ACTION
execute_action() {
  ACTION=$1
  case "${ACTION}" in
  "start") start_vms
    ;;
  "vms") print_vms
    ;;
  "status") list_running_vms
    ;;
  "stop") stop_running_vms
    ;;
  "pause") pause_running_vms
    ;;
  "resume") resume_paused_vms
    ;;
  *) echo "UNKNOWN ACTION_TYPE..."
    exit 1
    ;;
  esac
}

# VARIABLES FOR STORING SERVICE_TYPE & ACTION_TYPE
SERVICE_TYPE=""
ACTION_TYPE=""

# READING THE RUNTIME ARGUMENTS USING GETOPTS
while getopts ":s:a:" opt; do
  case "${opt}" in
  s) SERVICE_TYPE=${OPTARG}
    ;;
  a) ACTION_TYPE=${OPTARG}
    ;;
  :) echo "UNKNOWN ARGUMENTS..."
    usage
    ;;
  *) usage
    ;;
  esac
done

# CHECKING FOR MANDATORY ARGUMENTS AT RUNTIME
if [[ -z "${SERVICE_TYPE}" || -z "${ACTION_TYPE}" ]]; then
  usage
else
  echo "SERVICE_TYPE = ${SERVICE_TYPE}"
  echo "ACTION_TYPE_TYPE = ${ACTION_TYPE}"
  get_service_vms "${SERVICE_TYPE,,}"
  execute_action "${ACTION_TYPE,,}"
fi

# END OF THE SCRIPT