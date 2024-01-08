# Testing Confluent Kafka Setup


### Testing Zookeeper Quorum:

```
zookeeper-shell zookeeper:2181
```

#### Execute Zookeeper Commands

```
ls /
```

```
ls /brokers/topics/_schemas
```

```
get /brokers/topics/_schemas
```

### Testing Kafka Broker / Server:

#### List Topics

```
kafka-topics --bootstrap-server broker:9092 --list
```

#### Create Kafka Topic

```
kafka-topics --bootstrap-server broker:9092 --create --topic test1 --replication-factor 1 --partitions 5

kafka-topics --bootstrap-server broker:9092 --create --topic AvroTopic --replication-factor 1 --partitions 5
```

#### Produce Messages to Kafka Topic

```
kafka-console-producer --broker-list broker:9092 --topic test1
```

#### Consume Messages from Kafka Topic

```
kafka-console-consumer --bootstrap-server broker:9092 --topic test1 --from-beginning
```

#### Creating Schema Registry Subject

```
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json"  --data '{"schema" : "{\"type\":\"record\",\"name\":\"testrecord\",\"fields\":[{\"name\":\"message\",\"type\":\"string\"}]}"}' http://schemaregistry:8081/subjects/AvroTopic-value/versions/
```

#### Produce Avro Messages to Kafka Topic

```
kafka-avro-console-producer \
   --topic AvroTopic \
   --broker-list broker:9092 \
   --property value.schema='{"type":"record","name":"testrecord","fields":[{"name":"message","type":"string"}]}' \
   --property schema.registry.url=http://schemaregistry:8081
```

OR

```
kafka-avro-console-producer \
 --broker-list broker:9092 \
 --topic AvroTopic  \
 --property schema.registry.url=http://schemaregistry:8081 \
 --property value.schema.id=1
```

Avro Message:

```
{"message": "Hello World, Good Morning!!!"}
```

#### Consume Avro Messages from Kafka Topic

```
kafka-avro-console-consumer \
   --topic AvroTopic \
   --bootstrap-server broker:9092 \
   --property schema.registry.url=http://schemaregistry:8081 \
   --from-beginning
```

### KSQL

#### Login to KSQL Shell

```
ksql http://ksql:8088
```

```
LIST TOPICS;
```

```
PRINT AvroTopic from beginning;
```



