# Geo-Replication:

#### Pre-requisites

DmmAccess & web-server-logs on RDC Kafka Cluster


1. DmmAccess & web-server-logs topics on RDC & ORD should be created.
2. Mirror Maker service should be created and started.

3. /data01/docker/input_logs/log20170630.csv only file should be present
4. /data01/docker/input_logs/sample1.csv only file should be present

bin/kafka-topics \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 \
  --create \
  --topic web-server-logs \
  --partitions 30 \
  --replication-factor 3

bin/kafka-topics \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --create \
  --topic DmmAccess \
  --partitions 6 \
  --replication-factor 3

bin/kafka-topics \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --create \
  --topic web-server-logs \
  --partitions 30 \
  --replication-factor 3

# Demo 1 - Mirror Maker 1.0 - Geo Replication

DmmAccess, web-server-logs

ssh achoppadandi@node007.dev.dpl.kafka.cnvr.net

sudo su -

kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 \
  --list

kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --list

kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 \
  --describe \
  --topic DmmAccess

kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --describe \
  --topic DmmAccess

# Login to Node007

ssh achoppadandi@node004.dev.dpl.kafka.cnvr.net

sudo su -

cat /etc/systemd/system/kafka-mirror-maker.service

systemctl status kafka-mirror-maker.service

docker-compose -f /data01/docker/docker-compose-web-server-logs-producer.yaml ps -a

cp /data01/docker/input_logs/sample1.csv /data01/docker/input_logs/sample2.csv

End of MM1 Demo
=====================================================


# Demo 2 Mirror Maker - Geo Replication

### Login to the Mirror Maker & Mirror Maker 2 Node

```
ssh achoppadandi@node007.dev.dpl.kafka.cnvr.net
```

#### Become root User

```
sudo su -
```

### Status of MM2

```
systemctl status connect-mirror-maker.service
```

### Service script

```
cat /etc/systemd/system/connect-mirror-maker.service
```

### MM2 Configuration properties

```
cat /data01/configs/mm2-data-replication-new.properties
```

### List of Topics

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 \
  --list

kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --list
```

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 \
  --describe \
  --topic DmmAccess

kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --describe \
  --topic rdc.DmmAccess
```

### Start MM2

```
systemctl start connect-mirror-maker.service
```

### List of topics

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 \
  --list
```

### Generate some data

```
cp /data01/docker/input_logs/log20170701.csv /data01/docker/input_logs/log20170702.csv
```

```
cp /data01/docker/input_logs/log20170701.csv /data01/docker/input_logs/log20170703.csv
```

```
cp /data01/docker/input_logs/log20170701.csv /data01/docker/input_logs/log20170704.csv
```

End of MM2 Demo
=============================================================================


# Disaster Recovery


### List of topics

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

### Create Topics

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093 \
  --create \
  --topic apache-logs \
  --partitions 10 \
  --replication-factor 3
```

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --create \
  --topic tomcat-server-logs \
  --partitions 15 \
  --replication-factor 3
```

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093 \
  --create \
  --topic test1 \
  --partitions 10 \
  --replication-factor 3
```

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --create \
  --topic test2 \
  --partitions 15 \
  --replication-factor 3
```

### List of topics

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

### Create MM2 Properties file

```
clusters=rdc, ord
rdc.bootstrap.servers=node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093
ord.bootstrap.servers=node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093

#rdc and ord configurations. Default value for the following settings is 3.
#If you want more details about those internal configurations, please see https://docs.confluent.io/home/connect/userguide.html#kconnect-internal-topics
#and https://docs.confluent.io/platform/current/connect/references/allconfigs.html#distributed-worker-configuration
rdc.config.storage.replication.factor=3
ord.config.storage.replication.factor=3

rdc.offset.storage.replication.factor=3
ord.offset.storage.replication.factor=3

rdc.status.storage.replication.factor=3
ord.status.storage.replication.factor=3

rdc->ord.enabled=true
ord->rdc.enabled=true

# MirrorMaker configuration. Default value for the following settings is 3
offset-syncs.topic.replication.factor=3
heartbeats.topic.replication.factor=3
checkpoints.topic.replication.factor=3

topics=.*
groups=.*

tasks.max=10
replication.factor=3
refresh.topics.enabled=true
sync.topic.configs.enabled=true
refresh.topics.interval.seconds=30

topics.blacklist=.*[\-\.]internal, .*\.replica, __consumer_offsets
groups.blacklist=console-consumer-.*, connect-.*, __.*

# Enable heartbeats and checkpoints
rdc->ord.emit.heartbeats.enabled=true
rdc->ord.emit.checkpoints.enabled=true
ord->rdc.emit.heartbeats.enabled=true
ord->rdc.emit.checkpoints.enabled=true
```


## Connect Mirror Maker / Mirror Maker 2

### Login to the Mirror Maker & Mirror Maker 2 Node

```
ssh achoppadandi@node007.dev.dpl.kafka.cnvr.net
```

#### Become root User

```
sudo su -
```

### Service script

```
cat /etc/systemd/system/connect2-mirror-maker.service
```


### Service Script

```
[Unit]
Description=Setup Kafka Mirror Maker Service

[Service]
User=root
Group=root
Environment="KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/data01/confluent/etc/kafka/connect-log4j.properties"
Environment="KAFKA_HEAP_OPTS=-Xms1G -Xmx8G"
Environment="KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8096:/data01/jmx_exporter/kafka-connect.yaml"
ExecStart=/data01/confluent/bin/connect-mirror-maker /data01/configs/mm2-data-disaster-recovery.properties
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target

```

### To check the status of Connect Mirror Maker / Mirror Maker 2

```
systemctl status connect2-mirror-maker.service
```

### To Stop Connect Mirror Maker / Mirror Maker 2

```
systemctl stop connect2-mirror-maker.service
```

## Cleaning Up the ORD Cluster

### Login to the Kafka Brokers & Zookeeper Nodes:

```
ssh achoppadandi@node004.dev.dpl.kafka.cnvr.net
```

```
ssh achoppadandi@node005.dev.dpl.kafka.cnvr.net
```

```
ssh achoppadandi@node006.dev.dpl.kafka.cnvr.net
```

#### Become root User

```
sudo su -
```

### To check the status of Kafka Broker Service

```
systemctl status kafka2.service
```

### To stop Kafka Broker Service
```
kill -9 <PID>
```

***Note:*** On Node004 stop the Zookeeper service

### Cleanup Zookeeper

```
zookeeper-shell.sh node004.dev.dpl.kafka.cnvr.net:2181 
```

```
ls /

deleteall /kafka2
```

### Cleanup everything by deleting the Kafka Broker & Zookeeper data 

```
rm -rf /data01/data/kafka2/*
```

```
systemctl start kafka2.service
```

```
systemctl status kafka2.service
```

### List of topics

```
kafka-topics.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

### MM2 Properties file

```
cat /data01/configs/mm2-data-disaster-recovery-2.properties
```

### To Start Connect Mirror Maker / Mirror Maker 2

```
vi /etc/systemd/system/connect2-mirror-maker.service
```

```
[Unit]
Description=Setup Kafka Mirror Maker Service

[Service]
User=root
Group=root
Environment="KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/data01/confluent/etc/kafka/connect-log4j.properties"
Environment="KAFKA_HEAP_OPTS=-Xms1G -Xmx8G"
Environment="KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8096:/data01/jmx_exporter/kafka-connect.yaml"
ExecStart=/data01/confluent/bin/connect-mirror-maker /data01/configs/mm2-data-disaster-recovery-2.properties
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

```
systemctl daemon-reload
```

```
systemctl start connect2-mirror-maker.service
```

```
kafka-topics.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --list
```

```
kafka-console-consumer.sh \
  --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9093,node002.dev.dpl.kafka.cnvr.net:9093,node003.dev.dpl.kafka.cnvr.net:9093 \
  --topic apache-logs \
  --from-beginning
```

```
kafka-console-consumer.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --topic rdc.apache-logs \
  --from-beginning
```

```
kafka-console-consumer.sh \
  --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9093,node005.dev.dpl.kafka.cnvr.net:9093,node006.dev.dpl.kafka.cnvr.net:9093 \
  --topic rdc.ord.tomcat-server-logs \
  --from-beginning
```