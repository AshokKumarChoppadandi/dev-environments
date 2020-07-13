FROM ashokkumarchoppadandi/confluent-kafka-base:5.3.3

LABEL maintainer=AshokKumarChoppadandi<ashokkumar98778@gmail.com>

USER root

WORKDIR /

COPY ./schema-registry-docker-entrypoint.sh /
RUN chmod +x /schema-registry-docker-entrypoint.sh

ENV HOSTNAME localhost
ENV ZOOKEEPERS_LIST localhost:2181
ENV KAFKA_ADVERTISED_LISTENERS localhost:9092

ENTRYPOINT ["./schema-registry-docker-entrypoint.sh"]