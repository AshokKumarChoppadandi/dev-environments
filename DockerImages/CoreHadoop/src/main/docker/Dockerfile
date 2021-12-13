FROM centos:7

EXPOSE 22/tcp
EXPOSE 22/udp

USER root

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" description="CentOS with Java, Hadoop and Spark installation"

ENV HADOOP_DOWNLOAD_URL https://archive.apache.org/dist/hadoop/common/hadoop-2.7.6/hadoop-2.7.6.tar.gz

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
    && chown -R hadoop /home/hadoop/.ssh \
    && wget $HADOOP_DOWNLOAD_URL \
    && tar -xzvf hadoop-*.tar.gz -C /usr/local/ \
    && ln -s /usr/local/hadoop-* /usr/local/hadoop \
    && rm -rf /home/hadoop/hadoop*.tar.gz

ADD configs/ssh-config /home/hadoop/.ssh/config

COPY configs/* /usr/local/hadoop/etc/hadoop/
RUN mkdir -p /usr/local/hadoop/data/nameNode /usr/local/hadoop/data/dataNode /usr/local/hadoop/data/namesecondary /usr/local/hadoop/data/tmp /usr/local/hadoop/spark \
    && chown -R hadoop /usr/local/hadoop/data/nameNode /usr/local/hadoop/data/dataNode /usr/local/hadoop/data/namesecondary /usr/local/hadoop/data/tmp /usr/local/hadoop/spark \
    && echo $JAVA_HOME >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh \
    && echo HDFS_NAMENODE_USER=hadoop >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh \
    && echo HDFS_DATANODE_USER=hadoop >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh \
    && echo HDFS_SECONDARYNAMENODE_USER=hadoop >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh \
    && chown -R hadoop /home/hadoop/ \
    && chown -R hadoop /usr/local/hadoop*

ENV JAVA_HOME /usr/lib/jvm/java
ENV PATH $PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop

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

COPY apache-hadoop-docker-entrypoint.sh /home/hadoop/
RUN chmod +x /home/hadoop/apache-hadoop-docker-entrypoint.sh \
    && chown -R hadoop /home/hadoop/

USER hadoop

ENTRYPOINT ["./apache-hadoop-docker-entrypoint.sh"]
CMD ["sh"]