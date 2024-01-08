#!/bin/sh
#set -e

CORE_SITE=$HADOOP_CONF_DIR/core-site.xml
HDFS_SITE=$HADOOP_CONF_DIR/hdfs-site.xml
YARN_SITE=$HADOOP_CONF_DIR/yarn-site.xml
MAPRED_SITE=$HADOOP_CONF_DIR/mapred-site.xml
HIVE_SITE=$HIVE_CONF_DIR/hive-site.xml

# DEFINING A USAGE FUNCTION
usage() {
	echo "Invalid Argument - $1"
	echo "Usage: $0 [ namenode | secondarynamenode | historyserver | resourcemanager | slavenode ]"
	echo "Stopping execution!"
	exit 1
}

LOG_FILE_PATH="$HADOOP_HOME"/logs/hadoop--namenode-$(hostname).log

configure_properties() {
  # SETTING UP HADOOP SERVICES PROPERTIES
  sed -i -e "s|HADOOP_TMP_DIR|$HADOOP_TMP_DIR|g" "$CORE_SITE"
  sed -i -e "s|FS_DEFAULT_NAME|$FS_DEFAULT_NAME|g" "$CORE_SITE"

  sed -i -e "s|HADOOP_NAMENODE_DIR|$HADOOP_NAMENODE_DIR|g" "$HDFS_SITE"
  sed -i -e "s|HADOOP_DATANODE_DIR|$HADOOP_DATANODE_DIR|g" "$HDFS_SITE"
  sed -i -e "s|HADOOP_SECONDARY_NAMENODE_DIR|$HADOOP_SECONDARY_NAMENODE_DIR|g" "$HDFS_SITE"
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

  sed -i -e "s|JAVAX_JDO_OPTION_CONNECTIONURL|$JAVAX_JDO_OPTION_CONNECTIONURL|g" "$HIVE_SITE"
  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONDRIVERNAME/$JAVAX_JDO_OPTION_CONNECTIONDRIVERNAME/" "$HIVE_SITE"
  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONUSERNAME/$JAVAX_JDO_OPTION_CONNECTIONUSERNAME/" "$HIVE_SITE"
  sed -i -e "s/JAVAX_JDO_OPTION_CONNECTIONPASSWORD/$JAVAX_JDO_OPTION_CONNECTIONPASSWORD/" "$HIVE_SITE"
  sed -i -e "s/HIVE_START_CLEANUP_SCRATCHDIR/$HIVE_START_CLEANUP_SCRATCHDIR/" "$HIVE_SITE"
  sed -i -e "s|HIVE_EXEC_SCRATCHDIR|$HIVE_EXEC_SCRATCHDIR|g" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_TRANSPORT_MODE/$HIVE_SERVER2_TRANSPORT_MODE/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_PORT/$HIVE_SERVER2_THRIFT_HTTP_PORT/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_MAX_WORKER_THREADS/$HIVE_SERVER2_THRIFT_HTTP_MAX_WORKER_THREADS/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_MIN_WORKER_THREADS/$HIVE_SERVER2_THRIFT_HTTP_MIN_WORKER_THREADS/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_THRIFT_HTTP_PATH/$HIVE_SERVER2_THRIFT_HTTP_PATH/" "$HIVE_SITE"
  sed -i -e "s/HIVE_SERVER2_ENABLE_DOAS/$HIVE_SERVER2_ENABLE_DOAS/" "$HIVE_SITE"

}

start_namenode() {
  # FORMATTING NAMENODE
  echo "Formatting Namenode..."
  hdfs namenode -format

  # STARTING NAMENODE SERVICE
  echo "Starting Namenode..."
  hadoop-daemon.sh start namenode

  LOG_FILE_PATH="$HADOOP_HOME"/logs/hadoop--namenode-$(hostname).log
}

start_secondarynamenode() {
  # STARTING SECONDARY NAMENODE SERVICE
  echo "Starting Secondary Namenode..."
  hadoop-daemon.sh start secondarynamenode

  LOG_FILE_PATH=$HADOOP_HOME/logs/hadoop--secondarynamenode-$(hostname).log
}

start_resourcemanager() {
  # STARTING RESOURCE MANAGER SERVICE
  echo "Starting Resource Manager..."
  yarn-daemon.sh start resourcemanager

  LOG_FILE_PATH=$HADOOP_HOME/logs/yarn--resourcemanager-$(hostname).log
}

start_historyserver() {
  # STARTING HISTORY SERVER SERVICE
  echo "Starting MapReduce History Server..."
  mr-jobhistory-daemon.sh start historyserver

  LOG_FILE_PATH=$HADOOP_HOME/logs/mapred--historyserver-$(hostname).log
}

start_hiveserver() {
  hdfs dfs -mkdir -p /user/hive/warehouse
  hdfs dfs -chmod g+w /user/hive/warehouse
  hdfs dfs -mkdir /tmp
  hdfs dfs -chmod g+w /tmp

  schematool -dbType mysql -initSchema --verbose

  hive --service hiveserver2 --hiveconf hive.root.logger=DRFA --hiveconf hive.log.dir="${HIVE_HOME}"/logs/ --hiveconf hive.log.level=DEBUG &

  until [ -f "${HIVE_HOME}"/logs/hive.log ]
  do
    sleep 5
  done

  LOG_FILE_PATH=${HIVE_HOME}/logs/hive.log
}

start_slavenode() {
  # STARTING HISTORY SERVER SERVICE
  echo "Starting Datanode..."
  hadoop-daemon.sh start datanode

  echo "Starting Node Manager..."
  yarn-daemon.sh start nodemanager

  hdfs dfs -mkdir -p /user/root /user/hadoop
  hdfs dfs -chmod -R hadoop /user/hadoop

  LOG_FILE_PATH=/dev/null
}

start_sparkslave() {
  echo "Need to Implement"
}

start_sparkhive() {
  echo "Need to Implement"
}

SERVICE_TYPE=$1
SLAVE_NODE_TYPE=$2

select_and_start_slavenode() {
  case "${SLAVE_NODE_TYPE,,}" in
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
  start_hiveserver
  # select_and_start_slavenode
  start_slavenode
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

  "hive" | "hiveserver" | "hiveserver2" )
    echo "Starting Hive Server2 Service"
    start_hiveserver
  ;;

  "slavenode" )
    echo "Starting Slave Node"
    start_slavenode
  ;;

  * )
    usage "${SERVICE_TYPE,,}"
  ;;

esac

tail -f "$LOG_FILE_PATH"