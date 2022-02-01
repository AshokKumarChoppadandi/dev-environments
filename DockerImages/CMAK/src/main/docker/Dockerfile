FROM openjdk:11

LABEL maintainer="Ashok Kumar Choppadandi <ashhokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG CMAK_VERSION=3.0.0.5

ENV CMAK_DOWNLOAD_URL https://github.com/yahoo/CMAK/releases/download/${CMAK_VERSION}/cmak-${CMAK_VERSION}.zip
ENV CMAK_HOME_DIR /usr/local/cmak

RUN wget $CMAK_DOWNLOAD_URL \
    && unzip cmak-${CMAK_VERSION}.zip \
    && mv cmak-${CMAK_VERSION} /usr/local/ \
    && ln -s /usr/local/cmak-${CMAK_VERSION} ${CMAK_HOME_DIR} \
    && rm -rf cmak-${CMAK_VERSION}.zip

COPY ./cmak-docker-entrypoint.sh /

RUN chmod +x /cmak-docker-entrypoint.sh

ENV ZK_HOSTS localhost:2181
ENV KAFKA_MANAGER_USERNAME admin
ENV KAFKA_MANAGER_PASSWORD password
ENV APPLICATION_CONFIG_FILE $CMAK_HOME_DIR/conf/application.conf
ENV CONSUMER_PROPERTIES_FILE $CMAK_HOME_DIR/conf/consumer.properties
ENV HTTP_PORT 8080
ENV SECURITY_PROTOCOL PLAINTEXT
ENV KEY_DESERIALIZER org.apache.kafka.common.serialization.ByteArrayDeserializer
ENV VALUE_DESERIALIZER org.apache.kafka.common.serialization.ByteArrayDeserializer

ENTRYPOINT ["./cmak-docker-entrypoint.sh"]
CMD ["sh"]