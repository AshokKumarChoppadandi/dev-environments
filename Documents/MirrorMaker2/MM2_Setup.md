export KAFKA_OPTS=-javaagent:/home/achoppadandi/Hackathon/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=9095:/home/achoppadandi/Hackathon/jmx_exporter/kafka-connect.yaml && \
/home/achoppadandi/Hackathon/kafka/bin/connect-mirror-maker.sh /home/achoppadandi/Hackathon/mirror-maker-2/mm2-data-replication.properties

