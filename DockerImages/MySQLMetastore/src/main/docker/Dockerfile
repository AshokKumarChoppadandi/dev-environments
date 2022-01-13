FROM mysql:8

LABEL maintainer="AshokKumarChoppadandi<ashokkumar98778@gmail.com>" description="MySQL image modified for Hive Metastore"

ENV MYSQL_DATABASE metastore

COPY ./sql-scripts/add_privileges.sql /docker-entrypoint-initdb.d/