#/bin/bash

ARGUMENT="start"

if [[ ! -z $ARGUMENT ]]; then
    echo "Arguemnt is $ARGUMENT"
fi

if [[ "$ARGUMENT" == "start" ]]; then
    echo "Starting HDFS Services..."
    start_namenode
    start_secondary_namenode
    start_data_node
    echo "Starting YARN Service"
    start_resource_manager
    start_node_manager
    echo "Starting MR History Server"
    start_history_server
    echo "Starting HiveServer2"
    start_hive_server2
fi

if [[ "$ARGUMENT" == "stop" ]]; then
    echo "Stopping HiveServer2"
    stop_hive_server2

    echo "Starting MR History Server"
    stop_history_server

    echo "Stopping YARN Services"
    stop_node_manager
    stop_resource_manager

    echo "Stopping HDFS Services..."
    stop_data_node
    stop_secondary_namenode
    stop_namenode
fi