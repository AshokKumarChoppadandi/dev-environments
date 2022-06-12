bin/kafka-topics.sh --bootstrap-server node101.dev.hdp.kafka.cnvr.net:19092,node102.dev.hdp.kafka.cnvr.net:19092,node103.dev.hdp.kafka.cnvr.net:19092 --create --topic RtbNoBidTest --partitions 5 --replication-factor 3


bin/kafka-topics.sh --bootstrap-server node104.dev.hdp.kafka.cnvr.net:19092,node105.dev.hdp.kafka.cnvr.net:19092,node106.dev.hdp.kafka.cnvr.net:19092 --create --topic RtbNoBidTest --partitions 5 --replication-factor 3




export KAFKA_OPTS=-javaagent:/home/achoppadandi/Hackathon/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=9095:/home/achoppadandi/Hackathon/jmx_exporter/kafka-2_0_0.yml && \
/home/achoppadandi/Hackathon/kafka/bin/kafka-mirror-maker.sh --consumer.config /home/achoppadandi/Hackathon/mirror-maker/mm1_consumer.properties --producer.config /home/achoppadandi/Hackathon/mirror-maker/mm1_producer.properties --whitelist RtbNoBidTest --abort.on.send.failure true --num.streams 5 --offset.commit.interval.ms 60000


Creating the Topic with same configuration in the Target Cluster

Running on Target Cluster



Checking lag:

bin/kafka-consumer-groups --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --list

bin/kafka-consumer-groups --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --describe --group test-consumer-group-mm1



/data01/confluent/bin/kafka-mirror-maker --consumer.config /data01/configs/mm1_avro_consumer.properties --producer.config /data01/configs/mm1_avro_producer.properties --whitelist avro-topic-1 --abort.on.send.failure true --num.streams 5 --offset.commit.interval.ms 60000