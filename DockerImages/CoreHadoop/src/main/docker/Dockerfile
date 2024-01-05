FROM quay.io/centos/centos:stream8

EXPOSE 22/tcp
EXPOSE 22/udp

USER root

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

LABEL author="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" \
        description="CentOS 8 Stream with Java & Core Hadoop"

ARG HADOOP_VERSION=2.7.6

ENV HADOOP_DOWNLOAD_URL https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV JAVA_HOME /usr/lib/jvm/java
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop/

ENV HADOOP_TMP_DIR $HADOOP_HOME/data/tmp
ENV HADOOP_NAMENODE_DIR $HADOOP_HOME/data/namenode
ENV HADOOP_DATANODE_DIR $HADOOP_HOME/data/datanode
ENV HADOOP_SECONDARY_NAMENODE_DIR $HADOOP_HOME/data/namesecondary

RUN dnf clean all \
    && dnf update -y libselinux \
    && dnf install -y initscripts curl which tar sudo rsync openssh-server openssh-clients java-1.8.0-openjdk-devel wget \
    && mkdir /home/hadoop/.ssh \
    && wget --no-check-certificate $HADOOP_DOWNLOAD_URL \
    && tar -xzvf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local/ \
    && ln -s /usr/local/hadoop-${HADOOP_VERSION} $HADOOP_HOME \
    && rm -rf /home/hadoop/hadoop-${HADOOP_VERSION}.tar.gz

ADD configs/ssh-config /home/hadoop/.ssh/config

COPY configs/* ${HADOOP_CONF_DIR}

RUN mkdir -p ${HADOOP_TMP_DIR} ${HADOOP_NAMENODE_DIR} ${HADOOP_DATANODE_DIR} ${HADOOP_SECONDARY_NAMENODE_DIR} \
    && chown -R hadoop /home/hadoop/ \
    && chown -R hadoop ${HADOOP_HOME}*

ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

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

COPY apache-hadoop-docker-entrypoint.sh /home/hadoop/
COPY ./health_check.sh /home/hadoop/

RUN chmod +x /home/hadoop/apache-hadoop-docker-entrypoint.sh \
    && chmod +x /home/hadoop/health_check.sh \
    && chown -R hadoop /home/hadoop/

HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=5 CMD /home/hadoop/health_check.sh

USER hadoop

ENTRYPOINT ["./apache-hadoop-docker-entrypoint.sh"]
CMD ["sh"]