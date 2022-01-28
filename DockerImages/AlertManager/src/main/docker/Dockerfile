FROM alpine:latest

LABEL maintainer="Ashok Kumar Choppadandi <ashhokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG ALERT_MANAGER_DOWNLOAD_URL="https://github.com/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz"

ENV ALERT_MANAGER_HOME /usr/local/alertmanager

COPY ./alertmanager-docker-entrypoint.sh /

RUN wget $ALERT_MANAGER_DOWNLOAD_URL \
	&& tar -xf alertmanager*.tar.gz -C /usr/local/ \
    && ln -s /usr/local/alertmanager-* $ALERT_MANAGER_HOME \
    && rm -rf alertmanager-*.tar.gz \
    && mv $ALERT_MANAGER_HOME/alertmanager.yml $ALERT_MANAGER_HOME/alertmanager_default.yml \
    && chmod +x /alertmanager-docker-entrypoint.sh

ENV ALERT_MANAGER_HOST localhost
ENV ALERT_MANAGER_PORT 9093
ENV ALERT_MANAGER_CONFIG_FILE ""
ENV ALERT_MANAGER_DEFAULT_CONFIG_FILE $ALERT_MANAGER_HOME/alertmanager_default.yml

ENTRYPOINT ["./alertmanager-docker-entrypoint.sh"]
CMD ["sh"]