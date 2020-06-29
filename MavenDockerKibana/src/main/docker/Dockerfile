FROM centos:7

MAINTAINER AshokKumarChoppadandi "ashokkumar98778@gmail.com"

#RUN yum update -y
#RUN yum install java-1.8.0-openjdk-devel -y
#RUN yum install wget -y

ENV KIBANA_HOME /usr/local/kibana

RUN useradd -m -s /bin/bash kibana

WORKDIR /home/kibana

ADD ./lib/kibana*.tar.gz /usr/local/
#ENV KIBANA_DOWNLOAD_URL https://artifacts.elastic.co/downloads/kibana/kibana-7.8.0-linux-x86_64.tar.gz
#	RUN wget $KIBANA_DOWNLOAD_URL
COPY ./kibana-docker-entry-point.sh /home/kibana/
RUN chmod +x /home/kibana/kibana-docker-entry-point.sh && mv /usr/local/kibana* $KIBANA_HOME

COPY ./config/kibana.yml /usr/local/kibana/config/kibana.yml

RUN chown -R kibana:root /usr/local/kibana*

ENV KIBANA_SERVER_PORT 5601
ENV KIBANA_SERVER_HOST 0.0.0.0
ENV KIBANA_SERVER_NAME kibana-host
ENV ELASTICSEARCH_HOSTS ["http://localhost:9200"]

ENTRYPOINT ["/usr/local/kibana/bin/kibana"]
