docker run -idt \
-e HOSTNAME=broker \
-e BROKER_ID=0 \
-e KAFKA_LISTENERS="PLAINTEXT:\/\/0.0.0.0:9092" \
-e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT:\/\/broker:9092" \
-e ZOOKEEPERS_LIST=zookeeper:2181 \
--hostname broker \
--name broker \
--link zookeeper:zookeeper \
-p 9092:9092 \
ashokkumarchoppadandi/confluent-kafka-broker:latest sh