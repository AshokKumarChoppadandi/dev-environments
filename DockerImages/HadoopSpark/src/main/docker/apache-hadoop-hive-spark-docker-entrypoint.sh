#!/bin/sh
#set -e

HADOOP_CONFIG_DIR=$HADOOP_HOME/etc/hadoop/
HIVE_CONFIG_DIR=$HIVE_HOME/conf

CORE_SITE=$HADOOP_CONFIG_DIR/core-site.xml
HDFS_SITE=$HADOOP_CONFIG_DIR/hdfs-site.xml
YARN_SITE=$HADOOP_CONFIG_DIR/yarn-site.xml
MAPRED_SITE=$HADOOP_CONFIG_DIR/mapred-site.xml
HIVE_SITE=$HIVE_CONFIG_DIR/hive-site.xml
SPARK_DEFAULTS_CONF=$SPARK_CONF_DIR/spark-defaults.conf

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ namenode | secondarynamenode | historyserver | resourcemanager | slavenode | sparkhistoryserver]"
	echo "Stopping execution!"
	exit 1
}

LOG_FILE_PATH="$HADOOP_HOME"/logs/hadoop--namenode-$(hostname).log

configure_properties() {
  # SETTING UP HADOOP SERVICES PROPERTIES
  sed -i -e "s/HADOOP_TMP_DIR/$HADOOP_TMP_DIR/" "$CORE_SITE"
  sed -i -e "s/FS_DEFAULT_NAME/$FS_DEFAULT_NAME/" "$CORE_SITE"

  sed -i -e "s/DFS_NAMENODE_NAME_DIR/$DFS_NAMENODE_NAME_DIR/" "$HDFS_SITE"
  sed -i -e "s/DFS_DATANODE_DATA_DIR/$DFS_DATANODE_DATA_DIR/" "$HDFS_SITE"
  sed -i -e "s/DFS_NAMENODE_CHECKPOINT_DIR/$DFS_NAMENODE_CHECKPOINT_DIR/" "$HDFS_SITE"
  sed -i -e "s/DFS_REPLICATION/$DFS_REPLICATION/" "$HDFS_SITE"
  sed -i -e "s/DFS_NAMENODE_DATANODE_REGISTRATION_IP_HOSTNAME_CHECK/$DFS_NAMENODE_DATANODE_REGISTRATION_IP_HOSTNAME_CHECK/" "$HDFS_SITE"

  sed -i -e "s/YARN_ACL_ENABLE/$YARN_ACL_ENABLE/" "$YARN_SITE"
  sed -i -e "s/YARN_RESOURCEMANAGER_HOSTNAME/$YARN_RESOURCEMANAGER_HOSTNAME/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_AUX_SERVICES_MAPREDUCE_SHUFFLE_CLASS/$YARN_NODEMANAGER_AUX_SERVICES_MAPREDUCE_SHUFFLE_CLASS/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_AUX_SERVICES/$YARN_NODEMANAGER_AUX_SERVICES/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_RESOURCE_MEMORY_MB/$YARN_NODEMANAGER_RESOURCE_MEMORY_MB/" "$YARN_SITE"
  sed -i -e "s/YARN_SCHEDULER_MAXIMUM_ALLOCATION_MB/$YARN_SCHEDULER_MAXIMUM_ALLOCATION_MB/" "$YARN_SITE"
  sed -i -e "s/YARN_SCHEDULER_MINIMUM_ALLOCATION_MB/$YARN_SCHEDULER_MINIMUM_ALLOCATION_MB/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_RESOURCE_CPU_VCORES/$YARN_NODEMANAGER_RESOURCE_CPU_VCORES/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_VMEM_CHECK_ENABLED/$YARN_NODEMANAGER_VMEM_CHECK_ENABLED/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_DISK_HEALTH_CHECKER_MAX_DISK_UTILIZATION_PER_DISK_PERCENTAGE/$YARN_NODEMANAGER_DISK_HEALTH_CHECKER_MAX_DISK_UTILIZATION_PER_DISK_PERCENTAGE/" "$YARN_SITE"
  sed -i -e "s/YARN_NODEMANAGER_PMEM_CHECK_ENABLED/$YARN_NODEMANAGER_PMEM_CHECK_ENABLED/" "$YARN_SITE"

  sed -i -e "s/HISTORY_SERVER_HOST/$HISTORY_SERVER_HOST/" "$MAPRED_SITE"
  sed -i -e "s/MAPREDUCE_FRAMEWORK_NAME/$MAPREDUCE_FRAMEWORK_NAME/" "$MAPRED_SITE"
  sed -i -e "s/YARN_NODEMANAGER_RESOURCE_MEMORY_MB/$YARN_NODEMANAGER_RESOURCE_MEMORY_MB/" "$MAPRED_SITE"
  sed -i -e "s/YARN_SCHEDULER_MAXIMUM_ALLOCATION_MB/$YARN_SCHEDULER_MAXIMUM_ALLOCATION_MB/" "$MAPRED_SITE"
  sed -i -e "s/YARN_SCHEDULER_MINIMUM_ALLOCATION_MB/$YARN_SCHEDULER_MINIMUM_ALLOCATION_MB/" "$MAPRED_SITE"
  sed -i -e "s/YARN_NODEMANAGER_VMEM_CHECK_ENABLED/$YARN_NODEMANAGER_VMEM_CHECK_ENABLED/" "$MAPRED_SITE"
  sed -i -e "s/YARN_APP_MAPREDUCE_AM_RESOURCE_MB/$YARN_APP_MAPREDUCE_AM_RESOURCE_MB/" "$MAPRED_SITE"
  sed -i -e "s/YARN_APP_MAPREDUCE_AM_COMMAND_OPTS/$YARN_APP_MAPREDUCE_AM_COMMAND_OPTS/" "$MAPRED_SITE"
  sed -i -e "s/MAPREDUCE_MAP_CPU_VCORES/$MAPREDUCE_MAP_CPU_VCORES/" "$MAPRED_SITE"
  sed -i -e "s/MAPREDUCE_REDUCE_CPU_VCORES/$MAPREDUCE_REDUCE_CPU_VCORES/" "$MAPRED_SITE"

  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONURL/$JAVAX_JDO_OPTION_CONNECTIONURL/" "$HIVE_SITE"
  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONDRIVERNAME/$JAVAX_JDO_OPTION_CONNECTIONDRIVERNAME/" "$HIVE_SITE"
  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONUSERNAME/$JAVAX_JDO_OPTION_CONNECTIONUSERNAME/" "$HIVE_SITE"
  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONPASSWORD/$JAVAX_JDO_OPTION_CONNECTIONPASSWORD/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_TRANSPORT_MODE/$HIVE_SERVER2_TRANSPORT_MODE/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_PORT/$HIVE_SERVER2_THRIFT_HTTP_PORT/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_MAX_WORKER_THREADS/$HIVE_SERVER2_THRIFT_HTTP_MAX_WORKER_THREADS/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_MIN_WORKER_THREADS/$HIVE_SERVER2_THRIFT_HTTP_MIN_WORKER_THREADS/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_PATH/$HIVE_SERVER2_THRIFT_HTTP_PATH/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_ENABLE_DOAS/$HIVE_SERVER2_ENABLE_DOAS/" "$HIVE_SITE"

  sed -i -e "s/NAMENODE_HOST_NAME/$NAMENODE_HOST_NAME/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_MASTER/$SPARK_MASTER/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_DRIVER_MEMORY/$SPARK_DRIVER_MEMORY/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_EXECUTOR_MEMORY/$SPARK_EXECUTOR_MEMORY/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_YARN_AM_MEMORY/$SPARK_YARN_AM_MEMORY/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_EVENTLOG_ENABLED/$SPARK_EVENTLOG_ENABLED/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s|SPARK_EVENTLOG_DIR|$SPARK_EVENTLOG_DIR|" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_HISTORY_PROVIDER/$SPARK_HISTORY_PROVIDER/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s|SPARK_HISTORY_FS_LOGDIRECTORY|$SPARK_HISTORY_FS_LOGDIRECTORY|" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_HISTORY_FS_UPDATE_INTERVAL/$SPARK_HISTORY_FS_UPDATE_INTERVAL/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s/SPARK_HISTORY_UI_PORT/$SPARK_HISTORY_UI_PORT/" "$SPARK_DEFAULTS_CONF"
  sed -i -e "s|SPARK_HDFS_JAR_LIB|$SPARK_HDFS_JAR_LIB|" "$SPARK_DEFAULTS_CONF"

}

start_namenode() {
  # FORMATTING NAMENODE
  echo "Formatting Namenode..."
  hdfs namenode -format
  sleep 5

  # STARTING NAMENODE SERVICE
  echo "Starting Namenode..."
  hadoop-daemon.sh start namenode
  sleep 10
  LOG_FILE_PATH="$HADOOP_HOME"/logs/hadoop--namenode-$(hostname).log
}

start_secondarynamenode() {
  # STARTING SECONDARY NAMENODE SERVICE
  echo "Starting Secondary Namenode..."
  hadoop-daemon.sh start secondarynamenode
  sleep 10
  LOG_FILE_PATH=$HADOOP_HOME/logs/hadoop--secondarynamenode-$(hostname).log
}

start_resourcemanager() {
  # STARTING RESOURCE MANAGER SERVICE
  echo "Starting Resource Manager..."
  yarn-daemon.sh start resourcemanager
  sleep 10
  LOG_FILE_PATH=$HADOOP_HOME/logs/yarn--resourcemanager-$(hostname).log
}

start_historyserver() {
  # STARTING HISTORY SERVER SERVICE
  echo "Starting MapReduce History Server..."
  mr-jobhistory-daemon.sh start historyserver
  sleep 10
  LOG_FILE_PATH=$HADOOP_HOME/logs/mapred--historyserver-$(hostname).log
}

start_slavenode() {
  # STARTING HISTORY SERVER SERVICE
  echo "Starting Datanode..."
  hadoop-daemon.sh start datanode
  sleep 5

  echo "Starting Node Manager..."
  yarn-daemon.sh start nodemanager
  sleep 5

  LOG_FILE_PATH=/dev/null
}

start_spark() {
  echo "Starting Spark..."
  tail -f /dev/null
}

start_hiveslavenode() {
  # STARTING HISTORY SERVER SERVICE
  echo "Starting Datanode..."
  hadoop-daemon.sh start datanode
  sleep 5

  echo "Starting Node Manager..."
  yarn-daemon.sh start nodemanager
  sleep 120

  hdfs dfs -mkdir -p /user/hive/warehouse
  hdfs dfs -chmod g+w /user/hive/warehouse
  hdfs dfs -mkdir /tmp
  hdfs dfs -chmod g+w /tmp

  schematool -dbType mysql -initSchema --verbose

  hdfs dfs -chmod -R 777 /

  sleep 10

  hive --service hiveserver2 --hiveconf hive.root.logger=DRFA --hiveconf hive.log.level=DEBUG &

  LOG_FILE_PATH=/dev/null
}

start_spark_history_server() {
  echo "Starting Spark History Server"
  sleep 60
  hdfs dfs -mkdir -p hdfs://"${NAMENODE_HOST_NAME}":9000/"${SPARK_EVENTLOG_DIR}"
  hdfs dfs -mkdir -p hdfs://"${NAMENODE_HOST_NAME}":9000/"${SPARK_HDFS_JAR_LIB}"
  hdfs dfs -put "${SPARK_HOME}"/jars/*.jar hdfs://"${NAMENODE_HOST_NAME}":9000/"${SPARK_HDFS_JAR_LIB}"

  "$SPARK_HOME"/sbin/start-history-server.sh
  LOG_FILE_PATH=/dev/null
}

start_sparkhive() {
  echo "Need to Implement"
}

SERVICE_TYPE=$1
SLAVE_NODE_TYPE=$2

select_and_start_slavenode() {
  case "${SLAVE_NODE_TYPE,,}" in
      "hive" )
        start_hiveslavenode
      ;;

      "spark" )
        start_sparkslave
      ;;

      "sparkhive" )
        start_sparkhive
      ;;

      * )
        start_slavenode
      ;;
    esac
}

start_all() {
  start_namenode
  start_secondarynamenode
  start_resourcemanager
  start_historyserver
  select_and_start_slavenode
  LOG_FILE_PATH="$HADOOP_HOME"/logs/hadoop--namenode-$(hostname).log
}

echo "Input Service Type - ${SERVICE_TYPE}"
echo "Configuring the Hadoop Properties..."
configure_properties
case "${SERVICE_TYPE,,}" in
  "sh" )
    echo "Starting all the Apache Hadoop Services"
    start_all
  ;;

  "namenode" )
    echo "Starting Namenode Service..."
    start_namenode
  ;;

  "secondarynamenode" )
    echo "Starting Secondary Namenode Service..."
    start_secondarynamenode
  ;;

  "resourcemanager" )
    echo "Starting Resource Manager Service..."
    start_resourcemanager
  ;;

  "historyserver" )
    echo "Starting History Server Service"
    start_historyserver
  ;;

  "sparkhistoryserver" )
      echo "Starting History Server Service"
      start_spark_history_server
    ;;

  "slavenode" )
    echo "Starting Slave Node"
    select_and_start_slavenode
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac

tail -f "$LOG_FILE_PATH"