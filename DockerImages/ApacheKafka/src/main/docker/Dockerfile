FROM centos:7

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG APACHE_KAFKA_DOWNLOAD_URL=https://archive.apache.org/dist/kafka/2.6.1/kafka_2.12-2.6.1.tgz

ENV KAFKA_HOME /usr/local/kafka

RUN yum update -y \
    && yum install java-1.8.0-openjdk-devel wget -y \
    && wget $APACHE_KAFKA_DOWNLOAD_URL \
    && tar -xzvf kafka_*.tgz -C /usr/local/ \
    && ln -s /usr/local/kafka* $KAFKA_HOME \
    && rm -rf kafka_*.tgz

COPY ./configs /usr/local/configs

# ZOOKEEPER RUNTIME ARGUMENTS
ENV ZOOKEEPER_DATA_DIR "\/tmp\/zookeeper"
ENV ZOOKEEPER_CLIENT_PORT 2181
ENV ZOOKEEPER_MAX_CLIENT_CONNECTIONS 0
ENV ZOOKEEPER_ENABLE_SERVER false
ENV ZOOKEEPER_ADMIN_SERVER_PORT 8080

# KAFKA BROKER RUNTIME ARGUMENTS
ENV BROKER_ID 0
ENV KAFKA_LISTENERS "PLAINTEXT:\/\/0.0.0.0:9092"
ENV KAFKA_ADVERTISED_LISTENERS "PLAINTEXT:\/\/localhost:9092"
ENV NUM_NETWORK_THREADS 3
ENV NUM_IO_THREADS 8
ENV SOCKET_SEND_BUFFER_BYTES 102400
ENV SOCKET_RECEIVE_BUFFER_BYTES 102400
ENV SOCKET_REQUEST_MAX_BYTES 104857600
ENV LOG_DIRS "\/tmp\/kafka-logs"
ENV DEFAULT_PARTITIONS 1
ENV NUM_RECOVERY_THREADS_PER_DATA_DIR 1
ENV OFFSETS_TOPIC_REPLICATION_FACTOR 1
ENV TRANSACTION_STATE_LOG_REPLICATION_FACTOR 1
ENV TRANSACTION_STATE_LOG_MIN_ISR 1
ENV LOG_RETENTION_HOURS 168
ENV LOG_SEGMENT_BYTES 1073741824
ENV LOG_RETENTION_CHECK_INTERVAL_MS 300000
ENV ZOOKEEPER_CONNECT_LIST localhost:2181
ENV ZOOKEEPER_CONNECTION_TIMEOUT_MS 18000
ENV GROUP_INITIAL_REBALANCE_DELAY_MS 0

# KAFKA CONNECT RUNTIME ARGUMENTS
ENV BOOTSTRAP_SERVERS localhost:9092
ENV GROUP_ID connect-cluster
ENV KEY_CONVERTER org.apache.kafka.connect.json.JsonConverter
ENV VALUE_CONVERTER org.apache.kafka.connect.json.JsonConverter
ENV KEY_CONVERTER_SCHEMAS_ENABLE true
ENV VALUE_CONVERTER_SCHEMAS_ENABLE true
ENV OFFSET_STORAGE_TOPIC connect-offsets
ENV OFFSET_STORAGE_REPLICATION_FACTOR 1
ENV OFFSET_STORAGE_PARTITIONS 25
ENV CONFIG_STORAGE_TOPIC connect-configs
ENV CONFIG_STORAGE_REPLICATION_FACTOR 1
ENV STATUS_STORAGE_TOPIC connect-status
ENV STATUS_STORAGE_REPLICATION_FACTOR 1
ENV STATUS_STORAGE_PARTITIONS 5
ENV OFFSET_FLUSH_INTERVAL_MS 10000
ENV CONNECT_HOST 0.0.0.0
ENV CONNECT_PORT 8083
ENV CONNECT_REST_ADVERTISED_HOST localhost
ENV CONNECT_REST_ADVERTISED_PORT 8083
ENV PLUGIN_PATH "\/usr\/local\/kafka\/libs"

ENV JAVA_HOME "/usr/lib/jvm/java"
ENV PATH $KAFKA_HOME/bin:$JAVA_HOME/bin:$PATH

COPY ./apache-kafka-docker-entrypoint.sh /
RUN chmod +x /apache-kafka-docker-entrypoint.sh

ENTRYPOINT ["./apache-kafka-docker-entrypoint.sh"]
CMD ["sh"]

