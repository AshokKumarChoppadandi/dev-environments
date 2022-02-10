FROM centos:7

MAINTAINER AshokKumarChoppadandi "ashokkumar98778@gmail.com"

WORKDIR /home/kibana

ARG KIBANA_VERSION=7.17.0
ENV KIBANA_DOWNLOAD_URL https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
ENV KIBANA_HOME /usr/local/kibana

RUN useradd -m -s /bin/bash kibana \
    && yum install wget -y \
    && wget $KIBANA_DOWNLOAD_URL \
    && tar -xzvf /home/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz -C /usr/local/ \
    && ln -s /usr/local/kibana-${KIBANA_VERSION}-linux-x86_64 $KIBANA_HOME \
    && rm -rf /home/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz

COPY ./configs/kibana.yml /usr/local/kibana/config/kibana.yml
COPY ./kibana-docker-entrypoint.sh /home/kibana/

RUN chown -R kibana:root /usr/local/kibana* \
    && chmod +x /home/kibana/kibana-docker-entrypoint.sh \
    && chown -R kibana:kibana /home/kibana

ENV KIBANA_SERVER_PORT 5601
ENV KIBANA_SERVER_HOST 0.0.0.0
ENV KIBANA_SERVER_NAME kibana-host
ENV ELASTICSEARCH_HOSTS ["http://localhost:9200"]
ENV PATH $PATH:$KIBANA_HOME/bin

USER kibana
ENTRYPOINT ["/home/kibana/kibana-docker-entrypoint.sh"]
