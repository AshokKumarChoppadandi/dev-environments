FROM centos:7

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG APACHE_ZOOKEEPER_DOWNLOAD_URL=https://dlcdn.apache.org/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz

ENV ZOOKEEPER_HOME /usr/local/apache-zookeeper

RUN yum update -y \
    && yum install java-1.8.0-openjdk-devel wget -y \
    && wget $APACHE_ZOOKEEPER_DOWNLOAD_URL \
    && tar -xzvf apache-zookeeper*.tar.gz -C /usr/local/ \
    && ln -s /usr/local/apache-zookeeper* $ZOOKEEPER_HOME \
    && rm -rf apache-zookeeper*.tar.gz

ENV JAVA_HOME "/usr/lib/jvm/java"
ENV PATH $ZOOKEEPER_HOME/bin:$JAVA_HOME/bin:$PATH

COPY ./configs /usr/local/configs

# ZOOKEEPER RUNTIME ARGUMENTS
ENV TICK_TIME 2000
ENV INIT_LIMIT 5
ENV SYNC_LIMIT 2
ENV DATA_DIR "\/tmp\/zookeeper"
ENV CLIENT_PORT 2181
ENV MAX_CLIENT_CONNECTIONS 0
ENV METRICS_PROVIDER_HTTP_PORT 7000
ENV METRICS_PROVIDER_EXPORT_JVM_INFO true
ENV QUORUM "zookeeper1,zookeeper2,zookeeper3"
ENV ZOOKEEPER_ID 1

COPY ./zookeeper-docker-entrypoint.sh /
RUN chmod +x /zookeeper-docker-entrypoint.sh

ENTRYPOINT ["./zookeeper-docker-entrypoint.sh"]
CMD ["sh"]
