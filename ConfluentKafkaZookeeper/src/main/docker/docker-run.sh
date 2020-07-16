docker run -idt \
-e HOSTNAME=zookeeper \
-e ZOOKEEPER_CLIENT_PORT=2181 \
-e ZOOKEEPER_DATA_DIR="\/usr\/local\/confluent\/data\/zookeeper" \
-e ZOOKEEPER_TICK_TIME=2000 \
--hostname zookeeper \
--name zookeeper ashokkumarchoppadandi/confluent-kafka-zookeeper:latest sh
