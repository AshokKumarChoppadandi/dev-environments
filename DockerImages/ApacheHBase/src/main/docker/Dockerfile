FROM centos:7

EXPOSE 22/tcp
EXPOSE 22/udp

USER root

RUN useradd -m -s /bin/bash hadoop

WORKDIR /home/hadoop

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>" description="CentOS with HBASE installation"

ARG HBASE_VERSION=2.4.9
# ENV HBASE_DOWNLOAD_URL https://archive.apache.org/dist/hbase/1.4.9/hbase-1.4.9-bin.tar.gz
ENV HBASE_DOWNLOAD_URL https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz

ENV JAVA_HOME /usr/lib/jvm/java
ENV HBASE_HOME /usr/local/hbase
ENV HBASE_CONF_DIR /usr/local/configs

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
    && wget --no-check-certificate $HBASE_DOWNLOAD_URL \
    && tar -xzvf hbase-*.tar.gz -C /usr/local/ \
    && ln -s /usr/local/hbase-* $HBASE_HOME \
    && rm -rf /home/hadoop/hbase-*.tar.gz

ENV PATH $PATH:$JAVA_HOME/bin:$HBASE_HOME/bin

ADD configs/ssh-config /home/hadoop/.ssh/config

COPY configs/* $HBASE_CONF_DIR/

ENV HBASE_ROOT_DIR hdfs:\/\/localhost:9000\/hbase
ENV HBASE_CLUSTER_DISTRIBUTED true
ENV ZOOKEEPER_QUORUM localhost:2181
ENV ZOOKEEPER_ZNODE_PARENT \/hbase

COPY apache-hbase-docker-entrypoint.sh /home/hadoop/
RUN chmod +x /home/hadoop/apache-hbase-docker-entrypoint.sh \
    && chown -R hadoop /home/hadoop/ \
    && chown -R hadoop $HBASE_HOME* \
    && chown -R hadoop $HBASE_CONF_DIR

USER hadoop

ENTRYPOINT ["./apache-hbase-docker-entrypoint.sh"]
CMD ["sh"]