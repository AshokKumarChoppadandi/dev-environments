docker run -idt \
-e HOSTNAME=schemaregistry \
-e ZOOKEEPERS_LIST=zookeeper:2181 \
-e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT:\/\/broker:9092" \
--hostname schemaregistry \
--name schemaregistry \
--link zookeeper:zookeeper \
--link broker:broker \
-p 8081:8081 \
ashokkumarchoppadandi/confluent-schema-registry:latest sh