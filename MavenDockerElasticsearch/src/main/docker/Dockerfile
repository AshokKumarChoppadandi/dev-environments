FROM centos:7

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

RUN yum update -y
RUN yum install java-1.8.0-openjdk-devel -y
RUN yum install wget -y

ENV ES_HOME /usr/local/elasticsearch

RUN useradd -m -s /bin/bash elasticsearch

WORKDIR /home/elasticsearch

#COPY ./lib/elasticsearch*.tar.gz /home/elasticsearch
ENV ES_DOWNLOAD_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.8.0-linux-x86_64.tar.gz
RUN wget $ES_DOWNLOAD_URL
COPY ./es-docker-entry-point.sh /home/elasticsearch/
RUN chmod +x /home/elasticsearch/es-docker-entry-point.sh

RUN tar -xzvf elasticsearch*.tar.gz -C /usr/local/
RUN rm -rf *.tar.gz
RUN mv /usr/local/elasticsearch* $ES_HOME

COPY ./config/elasticsearch.yml /usr/local/elasticsearch/config/elasticsearch.yml

RUN chown -R elasticsearch:root /usr/local/elasticsearch*

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
ENV PATH $ES_HOME/bin:$PATH
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"

USER elasticsearch
ENTRYPOINT ["./es-docker-entry-point.sh"]
