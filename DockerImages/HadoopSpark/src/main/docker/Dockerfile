FROM centos:7

EXPOSE 22/tcp
EXPOSE 22/udp

USER root

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" description="CentOS with Java, Hadoop and Spark installation"

ARG HADOOP_VERSION=2.7.6
ARG HADOOP_MAJOR_VERSION=2
ARG HIVE_VERSION=2.3.9
ARG SPARK_VERSION=3.3.0
ARG MYSQL_CONNECTOR_VERSION=8.0.23

ENV HADOOP_DOWNLOAD_URL https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HIVE_DOWNLOAD_URL https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
ENV SPARK_DOWNLOAD_URL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION}.tgz
ENV MYSQL_CONNECTOR_JAR https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar

ENV JAVA_HOME /usr/lib/jvm/java
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HIVE_HOME /usr/local/apache-hive
ENV HIVE_CONF_DIR $HIVE_HOME/conf
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CONF_DIR $SPARK_HOME/conf

RUN yum clean all \
    && rpm --rebuilddb \
    && yum update -y libselinux \
    && yum install -y initscripts curl which tar sudo rsync openssh-server openssh-clients java-1.8.0-openjdk-devel wget \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && /usr/bin/ssh-keygen -A \
    && mkdir /home/hadoop/.ssh \
    && cp ~/.ssh/id_rsa* /home/hadoop/.ssh/ \
    && cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys \
    && chown -R hadoop /home/hadoop/.ssh

RUN wget $HADOOP_DOWNLOAD_URL --no-check-certificate \
    && tar -xzvf hadoop-*.tar.gz -C /usr/local/ \
    && ln -s /usr/local/hadoop-* /usr/local/hadoop \
    && rm -rf /home/hadoop/hadoop*.tar.gz

RUN mkdir -p $HADOOP_HOME/data/nameNode $HADOOP_HOME/data/dataNode $HADOOP_HOME/data/namesecondary $HADOOP_HOME/data/tmp $HADOOP_HOME/spark \
#     && chown -R hadoop /usr/local/hadoop/data/nameNode /usr/local/hadoop/data/dataNode /usr/local/hadoop/data/namesecondary /usr/local/hadoop/data/tmp /usr/local/hadoop/spark \
    # && echo $JAVA_HOME >> $HADOOP_CONF_DIR/hadoop-env.sh \
    && echo HDFS_NAMENODE_USER=hadoop >> $HADOOP_CONF_DIR/hadoop-env.sh \
    && echo HDFS_DATANODE_USER=hadoop >> $HADOOP_CONF_DIR/hadoop-env.sh \
    && echo HDFS_SECONDARYNAMENODE_USER=hadoop >> $HADOOP_CONF_DIR/hadoop-env.sh \
#     && chown -R hadoop /home/hadoop/ \
    && chown -R hadoop $HADOOP_HOME*

RUN wget $HIVE_DOWNLOAD_URL --no-check-certificate \
    && tar -xzvf apache-hive-*.tar.gz -C /usr/local  \
    && rm -rf /home/hadoop/apache-hive-*.tar.gz \
    && ln -s /usr/local/apache-hive-* $HIVE_HOME \
    && wget $MYSQL_CONNECTOR_JAR --no-check-certificate \
    && mv /home/hadoop/mysql-connector*.jar $HIVE_HOME/lib \
    && chown -R hadoop /home/hadoop/ \
    && chown -R hadoop $HIVE_HOME*

RUN wget $SPARK_DOWNLOAD_URL --no-check-certificate \
    && tar -xzvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION}.tgz -C /usr/local/ \
    && rm -rf /home/hadoop/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION}.tgz \
    && ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR_VERSION} $SPARK_HOME
    # && mv $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf

ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

ADD configs/ssh-config /home/hadoop/.ssh/config
COPY configs/hadoop/* $HADOOP_CONF_DIR/
COPY configs/hive/hive-site.xml $HIVE_CONF_DIR/
COPY configs/spark/spark-defaults.conf $SPARK_CONF_DIR/spark-defaults.conf

# NAMENODE PROPERTIES
ENV HADOOP_TMP_DIR "\/usr\/local\/hadoop\/data\/tmp"
ENV FS_DEFAULT_NAME "hdfs:\/\/localhost:9000"
ENV DFS_NAMENODE_NAME_DIR "\/usr\/local\/hadoop\/data\/namenode"
ENV DFS_DATANODE_DATA_DIR "\/usr\/local\/hadoop\/data\/datanode"
ENV DFS_NAMENODE_CHECKPOINT_DIR "\/usr\/local\/hadoop\/data\/namesecondary"
ENV DFS_REPLICATION 1
ENV DFS_NAMENODE_DATANODE_REGISTRATION_IP_HOSTNAME_CHECK false

# RESOURCE MANAGER PROPERTIES
ENV YARN_ACL_ENABLE 0
ENV YARN_RESOURCEMANAGER_HOSTNAME localhost
ENV YARN_NODEMANAGER_AUX_SERVICES_MAPREDUCE_SHUFFLE_CLASS org.apache.hadoop.mapred.ShuffleHandler
ENV YARN_NODEMANAGER_AUX_SERVICES mapreduce_shuffle
ENV YARN_NODEMANAGER_RESOURCE_MEMORY_MB 4096
ENV YARN_SCHEDULER_MAXIMUM_ALLOCATION_MB 4096
ENV YARN_SCHEDULER_MINIMUM_ALLOCATION_MB 512
ENV YARN_NODEMANAGER_RESOURCE_CPU_VCORES 2
ENV YARN_NODEMANAGER_VMEM_CHECK_ENABLED false
ENV YARN_NODEMANAGER_DISK_HEALTH_CHECKER_MAX_DISK_UTILIZATION_PER_DISK_PERCENTAGE 95
ENV YARN_NODEMANAGER_PMEM_CHECK_ENABLED false

# HISTORY SERVER PROPERTIES
ENV HISTORY_SERVER_HOST localhost
ENV MAPREDUCE_FRAMEWORK_NAME yarn
ENV YARN_APP_MAPREDUCE_AM_RESOURCE_MB 512
ENV YARN_APP_MAPREDUCE_AM_COMMAND_OPTS "-Xmx2048m"
ENV MAPREDUCE_MAP_CPU_VCORES 1
ENV MAPREDUCE_REDUCE_CPU_VCORES 1

# HIVE PROPERTIES
ENV JAVAX_JDO_OPTION_CONNECTIONURL "jdbc:mysql:\/\/localhost\/metastore?createDatabaseIfNotExist=true"
ENV JAVAX_JDO_OPTION_CONNECTIONDRIVERNAME com.mysql.cj.jdbc.Driver
ENV JAVAX_JDO_OPTION_CONNECTIONUSERNAME hive
ENV JAVAX_JDO_OPTION_CONNECTIONPASSWORD hive
ENV HIVE_SERVER2_TRANSPORT_MODE binary
ENV HIVE_SERVER2_THRIFT_HTTP_PORT 10001
ENV HIVE_SERVER2_THRIFT_HTTP_MAX_WORKER_THREADS 500
ENV HIVE_SERVER2_THRIFT_HTTP_MIN_WORKER_THREADS 5
ENV HIVE_SERVER2_THRIFT_HTTP_PATH cliservice
ENV HIVE_SERVER2_ENABLE_DOAS false

# SPARK PROPERTIES
ENV NAMENODE_HOST_NAME namenode
ENV SPARK_MASTER yarn
ENV SPARK_DRIVER_MEMORY 512m
ENV SPARK_EXECUTOR_MEMORY 512m
ENV SPARK_YARN_AM_MEMORY 512m
ENV SPARK_EVENTLOG_ENABLED true
ENV SPARK_EVENTLOG_DIR spark/yarn-logs
ENV SPARK_HISTORY_PROVIDER org.apache.spark.deploy.history.FsHistoryProvider
ENV SPARK_HISTORY_FS_LOGDIRECTORY spark/yarn-logs
ENV SPARK_HISTORY_FS_UPDATE_INTERVAL 10s
ENV SPARK_HISTORY_UI_PORT 4040
ENV SPARK_HDFS_JAR_LIB /user/spark/share/lib

COPY apache-hadoop-hive-spark-docker-entrypoint.sh /home/hadoop/
RUN chmod +x /home/hadoop/apache-hadoop-hive-spark-docker-entrypoint.sh \
    && chown -R hadoop /home/hadoop/

USER hadoop

ENTRYPOINT ["./apache-hadoop-hive-spark-docker-entrypoint.sh"]
CMD ["sh"]