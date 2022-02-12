FROM openjdk:11

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

WORKDIR /home/logstash

ARG LOGSTASH_VERSION=7.17.0
ENV LOGSTASH_DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}-linux-x86_64.tar.gz
ENV LOGSTASH_HOME /usr/local/logstash
ENV LOGSTASH_CONFIG_DIR $LOGSTASH_HOME/config
ENV LOGSTASH_CONFIG_FILE logstash_test.config

RUN useradd -m -s /bin/bash logstash \
    && wget $LOGSTASH_DOWNLOAD_URL \
    && tar -xzvf logstash-${LOGSTASH_VERSION}-linux-x86_64.tar.gz -C /usr/local/ \
    && rm -rf logstash-${LOGSTASH_VERSION}-linux-x86_64.tar.gz \
    && ln -s /usr/local/logstash-${LOGSTASH_VERSION} $LOGSTASH_HOME

COPY ./logstash-docker-entrypoint.sh /home/logstash/

RUN chown -R logstash:root /usr/local/logstash* \
    && chmod +x /home/logstash/logstash-docker-entrypoint.sh \
    && chown -R logstash:logstash /home/logstash

ENV LOGSTASH_HOSTNAME logstash
ENV LS_JAVA_HOME $JAVA_HOME
ENV PATH $JAVA_HOME/bin:$LOGSTASH_HOME/bin:$PATH
USER logstash

ENTRYPOINT ["./logstash-docker-entrypoint.sh"]