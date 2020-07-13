FROM centos:7 as builder
LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"
USER root

WORKDIR /

# ENV CONFLUENT_KAFKA_VERSION 5.3.3
ENV CONFLUENT_KAFKA_DOWNLOAD_URL https://packages.confluent.io/archive/5.3/confluent-5.3.3-2.12.tar.gz?_ga=2.20540280.1183036142.1594210431-1676542575.1594210431
RUN curl $CONFLUENT_KAFKA_DOWNLOAD_URL --output confluent.tar.gz \
   && tar -xzvf confluent.tar.gz -C /usr/local/ \
   && mv /usr/local/confluent* /usr/local/confluent \
   && mkdir /usr/local/confluent/data

# ADD ./lib/confluent-5.3.3-2.12.tar.gz /usr/local/
COPY ./confluent-kafka-docker-entrypoint.sh /confluent-kafka-docker-entrypoint.sh
RUN chmod +x /confluent-kafka-docker-entrypoint.sh
COPY ./config /usr/local/confluent/config

FROM centos:7
USER root
RUN yum update -y && yum install java-1.8.0-openjdk-devel -y
COPY --from=builder /usr/local/confluent /usr/local/confluent
COPY --from=builder /confluent-kafka-docker-entrypoint.sh /confluent-kafka-docker-entrypoint.sh

ENV HOSTNAME confluentkafka
ENV JAVA_HOME /usr/lib/jvm/java
ENV CONFLUENT_HOME /usr/local/confluent
ENV PATH $CONFLUENT_HOME/bin:$JAVA_HOME/bin:$PATH

ENTRYPOINT ["/confluent-kafka-docker-entrypoint.sh"]
CMD ["sh"]