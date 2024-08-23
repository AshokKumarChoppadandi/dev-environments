#!/bin/bash

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ start | stop ]"
	echo "Stopping execution!"
	exit 1
}

start_namenode() {
    /usr/local/hadoop/sbin/hadoop-daemon.sh start namenode
    sleep 5
}

start_secondary_namenode() {
    /usr/local/hadoop/sbin/hadoop-daemon.sh start secondarynamenode
    sleep 5
}

start_resource_manager() {
    /usr/local/hadoop/sbin/yarn-daemon.sh start resourcemanager
    sleep 5
}

start_data_node() {
    /usr/local/hadoop/sbin/hadoop-daemon.sh start datanode
    sleep 5
}

start_node_manager() {
    /usr/local/hadoop/sbin/yarn-daemon.sh start nodemanager
    sleep 5
}

start_history_server() {
    /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
    sleep 5
}

start_hive_server2() {
    HADOOP_HOME=/usr/local/hadoop
    /usr/local/hive/bin/hive --service hiveserver2 --hiveconf hive.root.logger=DRFA --hiveconf hive.log.level=DEBUG
}

# Stopping Services
stop_namenode() {
    /usr/local/hadoop/sbin/hadoop-daemon.sh stop namenode
    sleep 5
}

stop_secondary_namenode() {
    /usr/local/hadoop/sbin/hadoop-daemon.sh stop secondarynamenode
    sleep 5
}

stop_resource_manager() {
    /usr/local/hadoop/sbin/yarn-daemon.sh stop resourcemanager
    sleep 5
}

stop_data_node() {
    /usr/local/hadoop/sbin/hadoop-daemon.sh stop datanode
    sleep 5
}

stop_node_manager() {
    /usr/local/hadoop/sbin/yarn-daemon.sh stop nodemanager
    sleep 5
}

stop_history_server() {
    /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh stop historyserver
    sleep 5
}

stop_hive_server2() {
    HIVE_PROCESS_PID=$(pgrep -f RunJar)
    kill -9 $(HIVE_PROCESS_PID)
}


ARGUMENT=$1

if [[ -z "$ARGUMENT" ]]; then
    usage()
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
    echo "Starting HiveServer2"
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