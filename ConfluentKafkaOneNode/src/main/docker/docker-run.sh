docker run -idt \
--name confluentkafka \
--hostname confluentkafka \
-e HOSTNAME=confluentkafka \
-p 2181:2181 -p 8081:8081 -p 8083:8083 -p 9092:9092 \
ashokkumarchoppadandi/confluent-kafka-one-node:latest sh

docker exec -it confluentkafka sh

