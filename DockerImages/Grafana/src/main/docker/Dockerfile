FROM centos:7

LABEL maintainer="Ashok Kumar Choppadandi <ashhokkumar98778@gmail.com>"

USER root

WORKDIR /

ARG GRAFANA_DOWNLOAD_URL=https://dl.grafana.com/enterprise/release/grafana-enterprise-8.3.4.linux-amd64.tar.gz
ENV GRAFANA_HOME /usr/local/grafana
ENV PATH $PATH:$GRAFANA_HOME/bin

RUN yum install wget -y \
    && wget $GRAFANA_DOWNLOAD_URL \
	&& tar -xf grafana-*.tar.gz -C /usr/local/ \
	&& ln -s /usr/local/grafana-* $GRAFANA_HOME \
	&& rm -rf grafana-*.tar.gz

COPY ./grafana-docker-entrypoint.sh /
RUN chmod +x /grafana-docker-entrypoint.sh

ENV APP_MODE production
ENV GRAFANA_TEMP_DATA_DIR data
ENV TEMP_DATA_LIFETIME 24h
ENV LOGS_DIR data/log
ENV PLUGINS_DIR data/plugins
ENV PROVISIONING_DIR conf/provisioning
ENV ENFORCE_DOMAIN false
ENV PROTOCOL http
ENV HTTP_ADDR ""
ENV HTTP_PORT 3000
ENV SERVE_FROM_SUB_PATH false
ENV ROUTER_LOGGING false
ENV STATIC_ROOT_PATH public
ENV ENABLE_GZIP false
ENV CERT_FILE ""
ENV CERT_KEY ""
ENV READ_TIMEOUT 0
ENV DATABASE_TYPE sqlite3
ENV DATABASE_HOST 127.0.0.1:3306
ENV DATABASE_NAME grafana
ENV DATABASE_USER root
ENV DATABASE_PASSWORD ""
ENV DATABASE_URL ""
ENV MAX_IDLE_CONN 2
ENV MAX_OPEN_CONN ""
ENV CONN_MAX_LIFETIME 14400
ENV LOG_QUERIES ""
ENV SSL_MODE disable
ENV ISOLATION_LEVEL ""
ENV CA_CERT_PATH ""
ENV CLIENT_KEY_PATH ""
ENV CLIENT_CERT_PATH ""
ENV SERVER_CERT_NAME ""
ENV ENABLE_ANONYMOUS_ACCESS false
ENV ORG_NAME "Main Org."
ENV ORG_ROLE Admin
ENV DEFAULT_ADMIN_USER admin
ENV DEFAULT_ADMIN_PASSWORD admin

COPY configs/custom.ini $GRAFANA_HOME/conf/custom.ini
ENTRYPOINT ["./grafana-docker-entrypoint.sh"]
CMD ["sh"]