FROM quay.io/centos/centos:stream8

LABEL maintainer="Ashok Kumar Choppadandi <ashhokkumar98778@gmail.com>"

USER root

WORKDIR /root

ARG PYTHON_VERSION=3.8
ARG AIRFLOW_VERSION=2.7.3

ENV CONSTRAINTS_FILE https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt

ENV AIRFLOW_CONFIG_FILE /root/airflow/airflow-custom.cfg
ENV AIRFLOW_HOST localhost
ENV AIRFLOW_PORT 8080
ENV DAGS_FOLDER /root/airflow/dags
ENV EXECUTOR SequentialExecutor
ENV PARALLELISM 32
ENV MAX_ACTIVE_TASKS_PER_DAG 16
ENV DAGS_ARE_PAUSED_AT_CREATION True
ENV MAX_ACTIVE_RUNS_PER_DAG 16
ENV LOAD_EXAMPLES True
ENV PLUGINS_FOLDER /root/airflow/plugins

ENV AIRFLOW_DB_USER airflow_user
ENV AIRFLOW_DB_PASSWORD airflow_pass
ENV AIRFLOW_DB_HOST localhost
ENV AIRFLOW_DB_PORT 3306
ENV AIRFLOW_DB_NAME airflow_db
ENV SQL_ALCHEMY_CONN_PREFIX mysql+pymysql

# mysql+mysqldb://airflow_user@airflow_pass@localhost:3306/airflow_db

# mysql+pymysql://airflow_user:airflow_pass@192.168.0.134:3306/airflow_db

RUN dnf update -y \
    && dnf install python3.8 -y

RUN ln -s /usr/bin/pip3 /usr/bin/pip  \
    && pip install --upgrade pip \
    && pip install pymysql \
    && pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINTS_FILE}" \
    && airflow db init

# ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN ${SQL_ALCHEMY_CONN_PREFIX}://${AIRFLOW_DB_USER}:${AIRFLOW_DB_PASSWORD}@${AIRFLOW_DB_HOST}:${AIRFLOW_DB_PORT}/${AIRFLOW_DB_NAME}

# COPY ./configs/airflow.cfg /root/airflow/airflow.cfg
COPY ./airflow-docker-entrypoint.sh /root/

RUN chmod +x /root/airflow-docker-entrypoint.sh

ENTRYPOINT ["./airflow-docker-entrypoint.sh"]
CMD ["sh"]

