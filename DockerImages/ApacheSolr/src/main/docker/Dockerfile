FROM centos:7

LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"

USER root

RUN useradd -m -s /bin/bash solr

WORKDIR /home/solr

ARG APACHE_SOLR_DOWNLOAD_URL=https://dlcdn.apache.org/lucene/solr/8.11.1/solr-8.11.1.tgz

ENV JAVA_HOME /usr/lib/jvm/java
ENV SOLR_HOME /usr/local/solr
ENV SOLR_DATA_DIR /var/solr
COPY apache-solr-docker-entrypoint.sh /home/solr/

RUN yum update -y \
    && yum install java-1.8.0-openjdk-devel wget lsof -y \
    && wget $APACHE_SOLR_DOWNLOAD_URL \
    && tar -xzvf solr-*.tgz -C /usr/local/ \
    && ln -s /usr/local/solr* $SOLR_HOME \
    && rm -rf solr-*.tgz \
    && chmod +x /home/solr/apache-solr-docker-entrypoint.sh \
    && mkdir $SOLR_DATA_DIR \
    && chown -R solr /home/solr/ \
    && chown -R solr $SOLR_HOME* \
    && chown -R solr $SOLR_DATA_DIR*

ENV PATH $PATH:$JAVA_HOME/bin:$SOLR_HOME/bin
COPY configs/* $SOLR_DATA_DIR/

ENV MEMORY 1g
ENV SOLR_PORT 8983
ENV ZOOKEEPER_QUORUM localhost:2181

USER solr

ENTRYPOINT ["./apache-solr-docker-entrypoint.sh"]
CMD ["sh"]
