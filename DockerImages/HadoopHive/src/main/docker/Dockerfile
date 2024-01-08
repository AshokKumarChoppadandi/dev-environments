FROM quay.io/centos/centos:stream8

EXPOSE 22/tcp
EXPOSE 22/udp

USER root

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

LABEL author="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        description="CentOS 8 Stream with Java, CoreHadoop and Hive"

ARG HADOOP_VERSION=2.7.6
ARG HIVE_VERSION=2.3.9
ARG MYSQL_JAVA_CONNECTOR_VERSION=8.0.23

ENV HADOOP_DOWNLOAD_URL https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HIVE_DOWNLOAD_URL https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
ENV MYSQL_CONNECTOR_JAR https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_JAVA_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_JAVA_CONNECTOR_VERSION}.jar

ENV JAVA_HOME /usr/lib/jvm/java
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HIVE_HOME /usr/local/apache-hive
ENV HIVE_CONF_DIR $HIVE_HOME/conf

ENV HADOOP_TMP_DIR $HADOOP_HOME/data/tmp
ENV HADOOP_NAMENODE_DIR $HADOOP_HOME/data/namenode
ENV HADOOP_DATANODE_DIR $HADOOP_HOME/data/datanode
ENV HADOOP_SECONDARY_NAMENODE_DIR $HADOOP_HOME/data/namesecondary

RUN dnf clean all \
    && dnf update -y libselinux \
    && dnf install -y initscripts curl which tar sudo rsync openssh-server openssh-clients java-1.8.0-openjdk-devel wget ncurses \
    && mkdir /home/hadoop/.ssh \
    && wget  --no-check-certificate ${HADOOP_DOWNLOAD_URL} \
    && tar -xzvf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local/ \
    && ln -s /usr/local/hadoop-${HADOOP_VERSION} ${HADOOP_HOME} \
    && rm -rf /home/hadoop/hadoop-${HADOOP_VERSION}.tar.gz \
    && wget --no-check-certificate $HIVE_DOWNLOAD_URL \
    && tar -xzvf apache-hive-${HIVE_VERSION}-bin.tar.gz -C /usr/local \
    && rm -rf /home/hadoop/apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME}

ADD configs/ssh-config /home/hadoop/.ssh/config

COPY configs/hadoop/*  ${HADOOP_CONF_DIR}/

COPY configs/hive/hive-site.xml ${HIVE_CONF_DIR}/

RUN mkdir -p ${HADOOP_TMP_DIR} ${HADOOP_NAMENODE_DIR} ${HADOOP_DATANODE_DIR} ${HADOOP_SECONDARY_NAMENODE_DIR} ${HIVE_HOME}/logs \
    && wget --no-check-certificate $MYSQL_CONNECTOR_JAR \
    && mv /home/hadoop/mysql-connector-java-${MYSQL_JAVA_CONNECTOR_VERSION}.jar ${HIVE_HOME}/lib \
    && chown -R hadoop /home/hadoop/ \
    && chown -R hadoop ${HADOOP_HOME}* \
    && chown -R hadoop ${HIVE_HOME}*

ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin

# NAMENODE PROPERTIES
ENV FS_DEFAULT_NAME "hdfs://localhost:9000"
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
ENV JAVAX_JDO_OPTION_CONNECTIONURL "jdbc:mysql://localhost/metastore?createDatabaseIfNotExist=true"
ENV JAVAX_JDO_OPTION_CONNECTIONDRIVERNAME com.mysql.cj.jdbc.Driver
ENV JAVAX_JDO_OPTION_CONNECTIONUSERNAME hive
ENV JAVAX_JDO_OPTION_CONNECTIONPASSWORD hive
ENV HIVE_START_CLEANUP_SCRATCHDIR true
ENV HIVE_EXEC_SCRATCHDIR ${HIVE_HOME}/logs/
ENV HIVE_SERVER2_TRANSPORT_MODE binary
ENV HIVE_SERVER2_THRIFT_HTTP_PORT 10001
ENV HIVE_SERVER2_THRIFT_HTTP_MAX_WORKER_THREADS 500
ENV HIVE_SERVER2_THRIFT_HTTP_MIN_WORKER_THREADS 5
ENV HIVE_SERVER2_THRIFT_HTTP_PATH cliservice
ENV HIVE_SERVER2_ENABLE_DOAS false

COPY apache-hadoop-hive-docker-entrypoint.sh /home/hadoop/
COPY ./health_check.sh /home/hadoop/

RUN chmod +x /home/hadoop/apache-hadoop-hive-docker-entrypoint.sh \
    && chmod +x /home/hadoop/health_check.sh \
    && chown -R hadoop /home/hadoop/

HEALTHCHECK --interval=10s --timeout=30s --start-period=20s --retries=5 CMD /home/hadoop/health_check.sh

USER hadoop

ENTRYPOINT ["./apache-hadoop-hive-docker-entrypoint.sh"]
CMD ["sh"]