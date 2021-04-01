# Creating Confluent Kafka Base Docker Image using `docker-maven-plugin`

## Introduction:

This is the Maven project helps in building the Confluent Kafka Base Docker Image using `docker-maven-plugin`. [Click Here](https://github.com/AshokKumarChoppadandi/dev-environments/tree/develop/MavenDockerHelloWorld) To know more about the plugin and building the docker images from it. 

The Confluent Kafka Base Image will be required to build the dependent Images. Below are the list of Images which use this base image:

* Confluent Kafka Zookeeper
* Confluent Kafka Broker
* Confluent Schema Registry
* Confluent Kafka Connect
* Confluent REST Proxy
* Confluent KSQL

This image can also be used to run one node Confluent Kafka Cluster. All these images created as different Maven projects.


## Maven commands to Build & Push Image

***Build:***

The below is the maven command to build the Docker image and save it to our local machine.

```
mvn docker:build
```

Building an image from the latest version of Confluent Kafka. All the available versions of Confluent Kafka can be downloaded from [https://www.confluent.io/](confluent.io). [Click Here](https://www.confluent.io/previous-versions) to download the required version.

mvn docker:build \
-Dconfluent.kafka.download.url=https://packages.confluent.io/archive/5.3/confluent-5.3.3-2.12.tar.gz?_ga=2.53226664.1661594241.1594901768-1676542575.1594210431

***Push:***

The below maven command pushes the Confluent Kafka Base image to docker registry.

```
mvn docker:push
```

Pushing image to the remote repository, for example: Docker Registry - "docker.io"

```
mvn docker:push -Ddocker.push.registry=docker.io
```

Pushing image by passing the credentials like username and password.

```
mvn docker:push \
-Ddocker.push.registry=docker.io \
-Ddocker.hub.username=REPLACE_WITH_USERNAME \
-Ddocker.hub.password=REPLACE_WITH_PASSWORD
```

***Build & Push:***

The below maven command builds the docker image, save it local and pushes it to docker registry.

```
mvn clean install \
> -Dconfluent.kafka.download.url=https://packages.confluent.io/archive/5.3/confluent-5.3.3-2.12.tar.gz?_ga=2.53226664.1661594241.1594901768-1676542575.1594210431 \
> -Ddocker.push.registry=docker.io \
> -Ddocker.hub.username=REPLACE_WITH_USERNAME \
> -Ddocker.hub.password=REPLACE_WITH_PASSWORD
```

#### NOTE: Docker container cannot be created from this image directly like the other Maven projects in this repository.

## Launching 1 Node Confluent Kafka Cluster

***Starting the Docker Container:***

The below is the command used to launch the docker container.

```
docker run -idt \
-e ZOOKEEPER_DATA_DIR="\/usr\/local\/confluent\/zookeeper" \
-e ZOOKEEPER_CLIENT_PORT=2181 \
-e ZOOKEEPER_TICK_TIME=2000 \
-e BROKER_ID=0 \
-e KAFKA_LISTENERS="PLAINTEXT:\/\/0.0.0.0:9092" \
-e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT:\/\/broker:9092" \
-e KAFKA_DATA_DIRS="\/usr\/local\/confluent\/data\/kafka-logs" \
-e DEFAULT_KAFKA_TOPIC_PARTITIONS=3 \
-e ZOOKEEPERS_LIST=broker:2181 \
-e CONNECT_HOST=broker \
-e CONNECT_PORT=8083 \
-e KAFKA_CONNECT_CLUSTER_GROUP_ID=connect-cluster \
-e KAFKA_CONNECT_KEY_CONVERTOR=org.apache.kafka.connect.json.JsonConverter \
-e KAFKA_CONNECT_VALUE_CONVERTOR=org.apache.kafka.connect.json.JsonConverter \
-e SCHEMA_REGISTRY_URL="http:\/\/broker:8081" \
-e CONNECT_CONFIGS_TOPIC=connect_configs \
-e CONNECT_OFFSETS_TOPIC=connect_offsets \
-e CONNECT_STATUSES_TOPIC=connect_statuses \
-e CONFIG_STORAGE_REPLICATION_FACTOR=1 \
-e OFFSET_STORAGE_REPLICATION_FACTOR=1 \
-e STATUS_STORAGE_REPLICATION_FACTOR=1 \
-p 9092:9092 -p 8081:8081 -p 8082:8082 -p 8083:8083 \
--hostname broker --name broker ashokkumarchoppadandi/confluent-kafka-base:latest sh
```

***Logging into the Container:***

```
docker exec -it broker sh
```

***Setting the Configurations Properties:***

Replacing the configuration values with environment variables in configuration files.

```
sed -i -e "s/ZOOKEEPER_HOST/$ZOOKEEPER_HOST/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_CLIENT_PORT/$ZOOKEEPER_CLIENT_PORT/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_DATA_DIR/$ZOOKEEPER_DATA_DIR/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/ZOOKEEPER_TICK_TIME/$ZOOKEEPER_TICK_TIME/" /usr/local/confluent/config/zookeeper.properties
sed -i -e "s/BROKER_ID/$BROKER_ID/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_LISTENERS/$KAFKA_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_DATA_DIRS/$KAFKA_DATA_DIRS/" /usr/local/confluent/config/server.properties
sed -i -e "s/DEFAULT_KAFKA_TOPIC_PARTITIONS/$DEFAULT_KAFKA_TOPIC_PARTITIONS/" /usr/local/confluent/config/server.properties
sed -i -e "s/ZOOKEEPERS_LIST/$ZOOKEEPERS_LIST/" /usr/local/confluent/config/server.properties
sed -i -e "s/CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS/$CONFLUENT_METADATA_SERVER_ADVERTISED_LISTENERS/" /usr/local/confluent/config/server.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/KAFKA_CONNECT_CLUSTER_GROUP_ID/$KAFKA_CONNECT_CLUSTER_GROUP_ID/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/KAFKA_CONNECT_KEY_CONVERTOR/$KAFKA_CONNECT_KEY_CONVERTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/KAFKA_CONNECT_VALUE_CONVERTOR/$KAFKA_CONNECT_VALUE_CONVERTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/SCHEMA_REGISTRY_URL/$SCHEMA_REGISTRY_URL/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_CONFIGS_TOPIC/$CONNECT_CONFIGS_TOPIC/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_OFFSETS_TOPIC/$CONNECT_OFFSETS_TOPIC/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_STATUSES_TOPIC/$CONNECT_STATUSES_TOPIC/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONFIG_STORAGE_REPLICATION_FACTOR/$CONFIG_STORAGE_REPLICATION_FACTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/OFFSET_STORAGE_REPLICATION_FACTOR/$OFFSET_STORAGE_REPLICATION_FACTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/STATUS_STORAGE_REPLICATION_FACTOR/$STATUS_STORAGE_REPLICATION_FACTOR/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_HOST/$CONNECT_HOST/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/CONNECT_PORT/$CONNECT_PORT/" /usr/local/confluent/config/connect-avro-distributed.properties
sed -i -e "s/ZOOKEEPERS_LIST/$ZOOKEEPERS_LIST/" /usr/local/confluent/config/schema-registry.properties
sed -i -e "s/KAFKA_ADVERTISED_LISTENERS/$KAFKA_ADVERTISED_LISTENERS/" /usr/local/confluent/config/schema-registry.properties
```

***Starting the services:***

`nohup` command will be used to run the services in the background.

```
nohup zookeeper-server-start /usr/local/confluent/config/zookeeper.properties > zookeeper.log 2>&1 &
nohup kafka-server-start /usr/local/confluent/config/server.properties > broker.log 2>&1 &
nohup connect-distributed /usr/local/confluent/config/connect-avro-distributed.properties > connect.log 2>&1 &
nohup schema-registry-start /usr/local/confluent/config/schema-registry.properties > registry.log 2>&1 &
```

