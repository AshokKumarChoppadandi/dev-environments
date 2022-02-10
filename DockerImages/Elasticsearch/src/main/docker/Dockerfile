FROM centos:7

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

WORKDIR /home/elasticsearch

ARG ELASTICSEARCH_VERSION=7.17.0
ENV ES_DOWNLOAD_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz
ENV ES_HOME /usr/local/elasticsearch
ENV ES_CONFIG_DIR /usr/local/elasticsearch/config
ENV JAVA_HOME /usr/lib/jvm/java

RUN yum update -y \
    && useradd -m -s /bin/bash elasticsearch \
    && yum install java-11-openjdk java-11-openjdk-devel wget -y \
    && wget $ES_DOWNLOAD_URL \
    && tar -xzvf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz -C /usr/local/ \
    && rm -rf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz \
    && ln -s /usr/local/elasticsearch-${ELASTICSEARCH_VERSION} $ES_HOME

COPY ./configs/elasticsearch.yml ${ES_CONFIG_DIR}/elasticsearch.yml
COPY ./elastisearch-docker-entrypoint.sh /home/elasticsearch/

RUN chown -R elasticsearch:root /usr/local/elasticsearch* \
    && chmod +x /home/elasticsearch/elastisearch-docker-entrypoint.sh \
    && chown -R elasticsearch:elasticsearch /home/elasticsearch

ENV ES_CLUSTER_NAME elasticsearch
ENV ES_NODE_NAME node1
ENV ES_NODE_MASTER true
ENV ES_DATA_PATH $ES_HOME/data
ENV ES_LOGS_PATH $ES_HOME/logs
ENV ES_NETWORK_HOST 0.0.0.0
ENV ES_HTTP_PORT 9200
ENV ES_DISCOVERY_SEED_HOSTS "127.0.0.1, [::1]"
ENV ES_BOOTSTRAP_MEMORY_LOCK false
ENV ES_MASTER_NODES "node1"
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"

ENV ES_JAVA_HOME $JAVA_HOME
ENV PATH $JAVA_HOME/bin:$ES_HOME/bin:$PATH

USER elasticsearch

ENTRYPOINT ["/home/elasticsearch/elastisearch-docker-entrypoint.sh"]
