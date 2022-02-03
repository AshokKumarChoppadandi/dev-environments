FROM openjdk:8

LABEL maintainer="Ashok Kumar Choppadandi <ashhokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG KAFKA_MONITOR_DOWNLOAD_URL=https://github.com/linkedin/kafka-monitor.git
ENV KAFKA_MONITOR_HOME_DIR /usr/local/kafka-monitor

RUN cd /usr/local \
    && git clone ${KAFKA_MONITOR_DOWNLOAD_URL} \
    && cd ${KAFKA_MONITOR_HOME_DIR} \
    && ./gradlew jar

COPY configs/* /
COPY kafka-monitor-docker-entrypoint.sh /

