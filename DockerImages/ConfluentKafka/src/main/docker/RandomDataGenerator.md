# RAMDOM DATA GENERATOR USING KSQL-DATAGEN

### Download docker-compose file:

```
wget https://github.com/AshokKumarChoppadandi/dev-environments/blob/develop/DockerImages/ConfluentKafka/src/main/docker/docker-compose-confluent-kafka.yml
```

### Start the containers

```
docker-compose -f docker-compose-confluent-kafka.yml up -d
```

### Login to ksql container

```
docker exec -it <ksql container name> sh
```

### Create Avro schema file

```
cat > employees1.avsc
```

```
{
   "type":"record",
   "name":"Employee",
   "namespace":"com.bigdata.kafka.employee",
   "fields":[
      {
         "name":"eid",
         "type":{
            "type":"int",
            "arg.properties":{
               "iteration":{
                  "start":1,
                  "step":1
               }
            }
         }
      },
      {
         "name":"ename",
         "type":{
            "type":"string",
            "arg.properties":{
               "regex":"user_\\d{1,5}"
            }
         }
      },
      {
         "name":"esalary",
         "type":{
            "type":"int",
            "arg.properties":{
               "regex":"[0-9]",
               "range":{
                  "min":1000,
                  "max":999999
               }
            }
         }
      },
      {
         "name":"edept",
         "type":{
            "type":"string",
            "arg.properties":{
               "regex":"dept_\\d{1,2}"
            }
         }
      },
      {
         "name":"eage",
         "type":{
            "type":"int",
            "arg.properties":{
               "regex":"[0-9]",
               "range":{
                  "min":21,
                  "max":65
               }
            }
         }
      }
   ],
   "doc":"Employee Details"
}
```

`ctrl + d`

### Check the Avro schema file

```
cat employees1.avsc
```

### Execute the Ksql Data Generator

_**Syntax:**_

```
<path-to-confluent>/bin/ksql-datagen schema=<path-to-avro-file> format=<record format> topic=<kafka topic name> key=<name of key column> [options ...]
```

_**Example:**_

```
ksql-datagen \
    schema=/employees1.avsc \
    format=avro \
    topic=employees1 \
    key=eid \
    bootstrap-server=broker:9092 \
    iterations=10 \
    maxInterval=500 \
    propertiesFile=/usr/local/configs/ksql-server.properties \
schemaRegistryUrl=http://schemaregistry:8081
```

### Check from Console Consumer

```
kafka-avro-console-consumer \
    --bootstrap-server broker:9092 \
    --topic employees1 \
    --from-beginning \
    --property schema.registry.url=http://schemaregistry:8081
```

`ctrl + c`

### Check from KSQL Shell

```
ksql http://ksql:8088
```

#### KSQL Commands:

```
LIST TOPICS;

PRINT <TOPIC_NAME>;

PRINT <TOPIC_NAME> FROM BEGINNING;

PRINT <TOPIC_NAME> FROM BEGINNING LIMIT <NUMBER OF RECORDS TO LIMIT>;
```