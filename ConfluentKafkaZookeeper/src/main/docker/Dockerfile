FROM ashokkumarchoppadandi/confluent-kafka-base:5.3.3

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

WORKDIR /

COPY ./confluent-zookeeper-docker-entrypoint.sh /
RUN chmod +x /confluent-zookeeper-docker-entrypoint.sh

ENV HOSTNAME localhost
ENV ZOOKEEPER_HOST localhost
ENV ZOOKEEPER_CLIENT_PORT 2181
ENV ZOOKEEPER_DATA_DIR \/usr\/local\/confluent-5.3.3\/data\/zookeeper
ENV ZOOKEEPER_TICK_TIME 2000

ENTRYPOINT ["./confluent-zookeeper-docker-entrypoint.sh"]