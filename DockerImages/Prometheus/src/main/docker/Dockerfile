FROM alpine:latest

LABEL maintainer="Ashok Kumar Choppadandi <ashhokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG PROMETHEUS_VERSION=2.32.1

ARG PROMETHEUS_DOWNLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"

ENV PROMETHEUS_HOME /usr/local/prometheus

COPY ./prometheus-docker-entrypoint.sh /

RUN wget $PROMETHEUS_DOWNLOAD_URL \
	&& tar -xf prometheus*.tar.gz -C /usr/local/ \
    && ln -s /usr/local/prometheus* $PROMETHEUS_HOME \
    && rm -rf prometheus*.tar.gz \
    && mv $PROMETHEUS_HOME/prometheus.yml $PROMETHEUS_HOME/prometheus_default.yml \
    && chmod +x /prometheus-docker-entrypoint.sh

ENV PROMETHEUS_HOST localhost
ENV PROMETHEUS_PORT 9090
ENV PROMETHEUS_CONFIG_FILE ""
ENV PROMETHEUS_DEFAULT_CONFIG_FILE $PROMETHEUS_HOME/prometheus_default.yml
ENV PROMETHEUS_DATA_DIR $PROMETHEUS_HOME/data

ENTRYPOINT ["./prometheus-docker-entrypoint.sh"]
CMD ["sh"]