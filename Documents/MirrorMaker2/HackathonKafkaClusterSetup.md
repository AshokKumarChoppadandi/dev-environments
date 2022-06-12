Choose location:

Disk size of 400GB ----> /data01

sudo su -

ls /data01

# Kafka & Zookeeper Configuration Directory
mkdir /data01/configs

# Kafka & Zookeeper Data Directory
mkdir /data01/data

# JMX Exporter Directory
mkdir /data01/jmx_exporter && cd /data01/jmx_exporter/

wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.15.0/jmx_prometheus_javaagent-0.15.0.jar

wget https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/zookeeper.yaml

wget https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/kafka-2_0_0.yml

# Change directory
cd /data01/

# Download Kafka
wget https://archive.apache.org/dist/kafka/2.6.3/kafka_2.12-2.6.3.tgz

tar -xzf kafka_2.12-2.6.3.tgz

ln -s kafka_2.12-2.6.3 kafka

# Kafka & Zookeeper Installation Directory
ls /data01/kafka

# Set JAVA_HOME & KAFKA_HOME
vi /etc/profile

```
# Setting up JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java
export PATH=$PATH:$JAVA_HOME/bin

# Setting up KAFKA_HOME
export KAFKA_HOME=/data01/kafka
export PATH=$PATH:$KAFKA_HOME/bin
```

# Zookeeper Configuration Properties file

vi /data01/configs/zookeeper.properties

```
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# the directory where the snapshot is stored.
dataDir=/data01/data/zookeeper
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0
# Disable the adminserver by default to avoid port conflicts.
# Set the port to something non-conflicting if choosing to enable this
admin.enableServer=false
# admin.serverPort=8080
# Time units in milliseconds used by Zookeeper for heartbeats.
# The minimum session timeout will be twice the tickTime
tickTime=2000
# The number of ticks that can take for the initial synchronization
initLimit=10
# The number of ticks that can pass between the request and response
syncLimit=5
# Zookeeper servers. These are the servers defined in /etc/hosts file (DNS mocking)
server.1=node001.dev.dpl.kafka.cnvr.net:2888:3888
# Enabling 4 Letter Word commands
4lw.commands.whitelist=*
```

# Create myid file for Zookeeper

mkdir /data01/data/zookeeper
echo 1 >> /data01/data/zookeeper/myid

# Setting up Zookeeper as Service

vi /etc/systemd/system/zookeeper.service

```
[Unit]
Description=Setup Zookeeper Service

[Service]
User=root
Group=root
Environment="EXTRA_ARGS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8090:/data01/jmx_exporter/zookeeper.yaml"
ExecStart=/data01/kafka/bin/zookeeper-server-start.sh /data01/configs/zookeeper.properties
ExecStop=/data01/kafka//bin/zookeeper-server-stop.sh
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

systemctl daemon-reload

systemctl start zookeeper.service

systemctl status zookeeper.service 

systemctl enable zookeeper.service

================================================

# Configuring Kafka Broker

vi /data01/configs/server.properties

```
# The id of the broker. This must be set to a unique integer for each broker.
broker.id=1
# The address the socket server listens on. It will get the value returned from
# java.net.InetAddress.getCanonicalHostName()
listeners=PLAINTEXT://0.0.0.0:9092

# Hostname and port the broker will advertise to producers and consumers. If not set, 
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
advertised.listeners=PLAINTEXT://node001.dev.dpl.kafka.cnvr.net:9092
# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3
# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8
# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400
# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400
# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600
# A comma separated list of directories under which to store log files
log.dirs=/data01/data/kafka
# Default Replication factor 
default.replication.factor=3
# The default number of log partitions per topic.
num.partitions=8
# Minimum number of ISR to have in order to minimize the data loss.
min.insync.replicas=2
# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
num.recovery.threads.per.data.dir=1
# Switch to enable topic deletion or not, default value is false.
delete.topic.enable=false
# Auto creation of kafka topics.
auto.create.topics.enable=true
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168
# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824
# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000
# Zookeeper connection string 
zookeeper.connect=node001.dev.dpl.kafka.cnvr.net:2181/kafka
# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=18000
```

# Setting up Kafka as Service

vi /etc/systemd/system/kafka.service

```
[Unit]
Description=Setup Kafka Service

[Service]
User=root
Group=root
Environment="KAFKA_HEAP_OPTS=-Xmx2048M"
Environment="KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8095:/data01/jmx_exporter/kafka-2_0_0.yml"
ExecStart=/data01/kafka/bin/kafka-server-start.sh /data01/configs/server.properties
ExecStop=/data01/kafka/bin/kafka-server-stop.sh
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

systemctl daemon-reload

systemctl start kafka.service

systemctl status kafka.service 

systemctl enable kafka.service


========================

On Node 007

ssh achoppadandi@node007.dev.dpl.kafka.cnvr.net

sudo su -

# Create Configs Directory
mkdir /data01/configs

# JMX Exporter Directory
mkdir /data01/jmx_exporter && cd /data01/jmx_exporter/

wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.15.0/jmx_prometheus_javaagent-0.15.0.jar

vi kafka-2_0_0.yaml

```
lowercaseOutputName: true

rules:
# Special cases and very specific rules
- pattern : kafka.server<type=(.+), name=(.+), clientId=(.+), topic=(.+), partition=(.*)><>Value
  name: kafka_server_$1_$2
  type: GAUGE
  labels:
    clientId: "$3"
    topic: "$4"
    partition: "$5"
- pattern : kafka.server<type=(.+), name=(.+), clientId=(.+), brokerHost=(.+), brokerPort=(.+)><>Value
  name: kafka_server_$1_$2
  type: GAUGE
  labels:
    clientId: "$3"
    broker: "$4:$5"
- pattern : kafka.coordinator.(\w+)<type=(.+), name=(.+)><>Value
  name: kafka_coordinator_$1_$2_$3
  type: GAUGE

# Generic per-second counters with 0-2 key/value pairs
- pattern: kafka.(\w+)<type=(.+), name=(.+)PerSec\w*, (.+)=(.+), (.+)=(.+)><>Count
  name: kafka_$1_$2_$3_total
  type: COUNTER
  labels:
    "$4": "$5"
    "$6": "$7"
- pattern: kafka.(\w+)<type=(.+), name=(.+)PerSec\w*, (.+)=(.+)><>Count
  name: kafka_$1_$2_$3_total
  type: COUNTER
  labels:
    "$4": "$5"
- pattern: kafka.(\w+)<type=(.+), name=(.+)PerSec\w*><>Count
  name: kafka_$1_$2_$3_total
  type: COUNTER

- pattern: kafka.server<type=(.+), client-id=(.+)><>([a-z-]+)
  name: kafka_server_quota_$3
  type: GAUGE
  labels:
    resource: "$1"
    clientId: "$2"

- pattern: kafka.server<type=(.+), user=(.+), client-id=(.+)><>([a-z-]+)
  name: kafka_server_quota_$4
  type: GAUGE
  labels:
    resource: "$1"
    user: "$2"
    clientId: "$3"

# Generic gauges with 0-2 key/value pairs
- pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Value
  name: kafka_$1_$2_$3
  type: GAUGE
  labels:
    "$4": "$5"
    "$6": "$7"
- pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+)><>Value
  name: kafka_$1_$2_$3
  type: GAUGE
  labels:
    "$4": "$5"
- pattern: kafka.(\w+)<type=(.+), name=(.+)><>Value
  name: kafka_$1_$2_$3
  type: GAUGE

# Emulate Prometheus 'Summary' metrics for the exported 'Histogram's.
#
# Note that these are missing the '_sum' metric!
- pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Count
  name: kafka_$1_$2_$3_count
  type: COUNTER
  labels:
    "$4": "$5"
    "$6": "$7"
- pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.*), (.+)=(.+)><>(\d+)thPercentile
  name: kafka_$1_$2_$3
  type: GAUGE
  labels:
    "$4": "$5"
    "$6": "$7"
    quantile: "0.$8"
- pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.+)><>Count
  name: kafka_$1_$2_$3_count
  type: COUNTER
  labels:
    "$4": "$5"
- pattern: kafka.(\w+)<type=(.+), name=(.+), (.+)=(.*)><>(\d+)thPercentile
  name: kafka_$1_$2_$3
  type: GAUGE
  labels:
    "$4": "$5"
    quantile: "0.$6"
- pattern: kafka.(\w+)<type=(.+), name=(.+)><>Count
  name: kafka_$1_$2_$3_count
  type: COUNTER
- pattern: kafka.(\w+)<type=(.+), name=(.+)><>(\d+)thPercentile
  name: kafka_$1_$2_$3
  type: GAUGE
  labels:
    quantile: "0.$4"

# Generic gauges for MeanRate Percent
# Ex) kafka.server<type=KafkaRequestHandlerPool, name=RequestHandlerAvgIdlePercent><>MeanRate
- pattern: kafka.(\w+)<type=(.+), name=(.+)Percent\w*><>MeanRate
  name: kafka_$1_$2_$3_percent
  type: GAUGE
- pattern: kafka.(\w+)<type=(.+), name=(.+)Percent\w*><>Value
  name: kafka_$1_$2_$3_percent
  type: GAUGE
- pattern: kafka.(\w+)<type=(.+), name=(.+)Percent\w*, (.+)=(.+)><>Value
  name: kafka_$1_$2_$3_percent
  type: GAUGE
  labels:
    "$4": "$5"
```

vi kafka-connect.yaml

```
lowercaseOutputName: true
rules:
  #kafka.connect:type=app-info,client-id="{clientid}"
  #kafka.consumer:type=app-info,client-id="{clientid}"
  #kafka.producer:type=app-info,client-id="{clientid}"
  - pattern: 'kafka.(.+)<type=app-info, client-id=(.+)><>start-time-ms'
    name: kafka_$1_start_time_seconds
    labels:
      clientId: "$2"
    help: "Kafka $1 JMX metric start time seconds"
    type: GAUGE
    valueFactor: 0.001
  - pattern: 'kafka.(.+)<type=app-info, client-id=(.+)><>(commit-id|version): (.+)'
    name: kafka_$1_$3_info
    value: 1
    labels:
      clientId: "$2"
      $3: "$4"
    help: "Kafka $1 JMX metric info version and commit-id"
    type: GAUGE
#kafka.producer:type=producer-topic-metrics,client-id="{clientid}",topic="{topic}"", partition="{partition}"
  #kafka.consumer:type=consumer-fetch-manager-metrics,client-id="{clientid}",topic="{topic}"", partition="{partition}"
  - pattern: kafka.(.+)<type=(.+)-metrics, client-id=(.+), topic=(.+), partition=(.+)><>(.+-total|compression-rate|.+-avg|.+-replica|.+-lag|.+-lead)
    name: kafka_$2_$6
    labels:
      clientId: "$3"
      topic: "$4"
      partition: "$5"
    help: "Kafka $1 JMX metric type $2"
    type: GAUGE
#kafka.producer:type=producer-topic-metrics,client-id="{clientid}",topic="{topic}"
  #kafka.consumer:type=consumer-fetch-manager-metrics,client-id="{clientid}",topic="{topic}"", partition="{partition}"
  - pattern: kafka.(.+)<type=(.+)-metrics, client-id=(.+), topic=(.+)><>(.+-total|compression-rate|.+-avg)
    name: kafka_$2_$5
    labels:
      clientId: "$3"
      topic: "$4"
    help: "Kafka $1 JMX metric type $2"
    type: GAUGE
#kafka.connect:type=connect-node-metrics,client-id="{clientid}",node-id="{nodeid}"
  #kafka.consumer:type=consumer-node-metrics,client-id=consumer-1,node-id="{nodeid}"
  - pattern: kafka.(.+)<type=(.+)-metrics, client-id=(.+), node-id=(.+)><>(.+-total|.+-avg)
    name: kafka_$2_$5
    labels:
      clientId: "$3"
      nodeId: "$4"
    help: "Kafka $1 JMX metric type $2"
    type: UNTYPED
#kafka.connect:type=kafka-metrics-count,client-id="{clientid}"
  #kafka.consumer:type=consumer-fetch-manager-metrics,client-id="{clientid}"
  #kafka.consumer:type=consumer-coordinator-metrics,client-id="{clientid}"
  #kafka.consumer:type=consumer-metrics,client-id="{clientid}"
  - pattern: kafka.(.+)<type=(.+)-metrics, client-id=(.*)><>(.+-total|.+-avg|.+-bytes|.+-count|.+-ratio|.+-age|.+-flight|.+-threads|.+-connectors|.+-tasks|.+-ago)
    name: kafka_$2_$4
    labels:
      clientId: "$3"
    help: "Kafka $1 JMX metric type $2"
    type: GAUGE
#kafka.connect:type=connector-task-metrics,connector="{connector}",task="{task}<> status"
  - pattern: 'kafka.connect<type=connector-task-metrics, connector=(.+), task=(.+)><>status: ([a-z-]+)'
    name: kafka_connect_connector_status
    value: 1
    labels:
      connector: "$1"
      task: "$2"
      status: "$3"
    help: "Kafka Connect JMX Connector status"
    type: GAUGE
#kafka.connect:type=task-error-metrics,connector="{connector}",task="{task}"
  #kafka.connect:type=source-task-metrics,connector="{connector}",task="{task}"
  #kafka.connect:type=sink-task-metrics,connector="{connector}",task="{task}"
  #kafka.connect:type=connector-task-metrics,connector="{connector}",task="{task}"
  - pattern: kafka.connect<type=(.+)-metrics, connector=(.+), task=(.+)><>(.+-total|.+-count|.+-ms|.+-ratio|.+-avg|.+-failures|.+-requests|.+-timestamp|.+-logged|.+-errors|.+-retries|.+-skipped)
    name: kafka_connect_$1_$4
    labels:
      connector: "$2"
      task: "$3"
    help: "Kafka Connect JMX metric type $1"
    type: GAUGE
#kafka.connect:type=connector-metrics,connector="{connector}"
  #kafka.connect:type=connect-worker-metrics,connector="{connector}"
  - pattern: kafka.connect<type=connect-worker-metrics, connector=(.+)><>([a-z-]+)
    name: kafka_connect_worker_$2
    labels:
      connector: "$1"
    help: "Kafka Connect JMX metric $1"
    type: GAUGE
#kafka.connect:type=connect-worker-metrics
  - pattern: kafka.connect<type=connect-worker-metrics><>([a-z-]+)
    name: kafka_connect_worker_$1
    help: "Kafka Connect JMX metric worker"
    type: GAUGE
#kafka.connect:type=connect-worker-rebalance-metrics
  - pattern: kafka.connect<type=connect-worker-rebalance-metrics><>([a-z-]+)
    name: kafka_connect_worker_rebalance_$1
    help: "Kafka Connect JMX metric rebalance information"
    type: GAUGE
#kafka.connect.mirror:type=MirrorSourceConnector
  - pattern: kafka.connect.mirror<type=MirrorSourceConnector, target=(.+), topic=(.+), partition=([0-9]+)><>([a-z-]+)
    name: kafka_connect_mirror_source_connector_$4
    help: Kafka Connect MM2 Source Connector Information
    labels:
      destination: "$1"
      topic: "$2"
      partition: "$3"
    type: GAUGE
#kafka.connect.mirror:type=MirrorCheckpointConnector
  - pattern: kafka.connect.mirror<type=MirrorCheckpointConnector, source=(.+), target=(.+)><>([a-z-]+)
    name: kafka_connect_mirror_checkpoint_connector_$3
    help: Kafka Connect MM2 Checkpoint Connector Information
    labels:
      source: "$1"
      target: "$2"
    type: GAUGE

```

# Download Kafka

cd /data01

wget https://archive.apache.org/dist/kafka/2.6.3/kafka_2.12-2.6.3.tgz

tar -xzf kafka_2.12-2.6.3.tgz

ln -s kafka_2.12-2.6.3 kafka

# Set JAVA_HOME & KAFKA_HOME
vi /etc/profile

```
# Setting up JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java
export PATH=$PATH:$JAVA_HOME/bin

# Setting up KAFKA_HOME
export KAFKA_HOME=/data01/kafka
export PATH=$PATH:$KAFKA_HOME/bin
```

# MM1 Hands-on

## MM1 Configuration files

vi mm1_producer.properties

```
bootstrap.servers=node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092
batch.size=100
client.id=mm1-apache-logs-producer
max.in.flight.requests.per.connection=1
retries=2147483647
acks=-1
block.on.buffer.full=true
```

vi mm1_consumer.properties

```
bootstrap.servers=node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092
group.id=mm1-apache-logs-consumer-group
exclude.internal.topics=true
client.id=mm1-apache-logs-consumer
auto.commit.enabled=false
socket.send.buffer.bytes=102400
fetch.max.bytes=52428800
```

## Create Topic on RDC Kafka Cluster

kafka-topics.sh --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --create --topic apache-logs --partitions 20 --replication-factor 3

kafka-topics.sh --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --list

kafka-topics.sh --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --describe --topic apache-logs

## Create Topic on ORD Kafka Cluster

kafka-topics.sh --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 --create --topic apache-logs --partitions 20 --replication-factor 3

kafka-topics.sh --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 --list

kafka-topics.sh --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 --describe --topic apache-logs

## Run MM1 Manually

export KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8090:/data01/jmx_exporter/kafka-2_0_0.yaml && \
/data01/kafka/bin/kafka-mirror-maker.sh --consumer.config /data01/configs/mm1_consumer.properties --producer.config /data01/configs/mm1_producer.properties --whitelist apache-logs --abort.on.send.failure true --num.streams 20 --offset.commit.interval.ms 60000

## Produce Messages to RDC Data Centre

kafka-console-producer --broker-list node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --topic apache-logs

```
> 73.222.244.jad,2017-06-25,23:59:59,0.0,1078820.0,0000889812-00-001498,.txt,200.0,389982.0,0.0,0.0,0.0,10.0,0.0,
> 73.253.66.iah,2017-06-25,23:59:59,0.0,1324948.0,0001144204-16-115196,-index.htm,200.0,2754.0,1.0,0.0,0.0,1.0,0.0,
> 86.153.150.jad,2017-06-25,23:59:59,0.0,1417398.0,0001104659-11-050043,-index.htm,200.0,2762.0,1.0,0.0,0.0,10.0,0.0,
> 86.153.150.jad,2017-06-25,23:59:59,0.0,898437.0,0001140361-11-003532,doc1.xml,200.0,1610.0,0.0,0.0,0.0,10.0,0.0,
> 86.153.150.jad,2017-06-25,23:59:59,0.0,1417398.0,0001104659-11-050043,a11-25441_18ka.htm,200.0,3110.0,0.0,0.0,0.0,10.0,0.0,
> 86.153.150.jad,2017-06-25,23:59:59,0.0,1418135.0,0001299933-11-002701,-index.htm,200.0,2675.0,1.0,0.0,0.0,10.0,0.0,
> 86.153.150.jad,2017-06-25,23:59:59,0.0,72331.0,0001481600-11-000026,edgar.xml,200.0,2120.0,0.0,0.0,0.0,10.0,0.0,
> 94.156.218.jad,2017-06-25,23:59:59,0.0,1167365.0,0001193125-17-211746,-index.htm,200.0,7449.0,1.0,0.0,0.0,10.0,0.0,
> 94.156.218.jad,2017-06-25,23:59:59,0.0,1361113.0,0001171843-17-003806,.txt,200.0,9045.0,0.0,0.0,0.0,10.0,0.0,
> 94.156.218.jad,2017-06-25,23:59:59,0.0,1425287.0,0001213900-17-006798,-index.htm,200.0,7578.0,1.0,0.0,0.0,10.0,0.0,
```

## Consume Messages from ORD Data Centre

kafka-console-consumer --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 --topic apache-logs --from-beginning


## MM1 Setup as Service

vi /etc/systemd/system/kafka-mirror-maker.service

```
[Unit]
Description=Setup Kafka Mirror Maker Service

[Service]
User=root
Group=root
Environment="KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8090:/data01/jmx_exporter/kafka-2_0_0.yaml"
ExecStart=/data01/kafka/bin/kafka-mirror-maker.sh --consumer.config /data01/configs/mm1_consumer.properties --producer.config /data01/configs/mm1_producer.properties --whitelist apache-logs --abort.on.send.failure true --num.streams 20 --offset.commit.interval.ms 60000
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

systemctl daemon-reload

systemctl start kafka-mirror-maker.service

systemctl status kafka-mirror-maker.service

systemctl enable kafka-mirror-maker.service


# MM2 Hands-on

## Create Topic on RDC Kafka Cluster

kafka-topics.sh --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --create --topic web-server-logs --partitions 20 --replication-factor 3

kafka-topics.sh --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --list

kafka-topics.sh --bootstrap-server node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --describe --topic web-server-logs

## Create MM2 proeprties file
vi mm2-data-replication.properties

```
# Basic Settings
clusters = rdc, ord
rdc.bootstrap.servers = node101.dev.hdp.kafka.cnvr.net:19092,node102.dev.hdp.kafka.cnvr.net:19092,node103.dev.hdp.kafka.cnvr.net:19092
ord.bootstrap.servers = node104.dev.hdp.kafka.cnvr.net:19092,node105.dev.hdp.kafka.cnvr.net:19092,node106.dev.hdp.kafka.cnvr.net:19092

# Kafka Connect Configurations
rdc.config.storage.replication.factor=3
ord.config.storage.replication.factor=3

rdc.offset.storage.replication.factor=3
ord.offset.storage.replication.factor=3

rdc.status.storage.replication.factor=3
ord.status.storage.replication.factor=3

tasks.max = 20
replication.factor = 3
refresh.topics.enabled=true
sync.topic.configs.enabled=true
refresh.topics.interval.seconds=30

rdc->ord.emit.heartbeats.enabled=true
rdc->ord.emit.checkpoints.enabled=true

# Define replication flows
rdc->ord.enabled = true
rdc->ord.topics = web-server-logs

# MirrorMaker configuration. Default value for the following settings is 3
offset-syncs.topic.replication.factor=3
heartbeats.topic.replication.factor=3
checkpoints.topic.replication.factor=3

# source cluster over writes
rdc.max.poll.records = 20000
rdc.receive.buffer.bytes = 33554432
rdc.send.buffer.bytes = 33554432
rdc.max.partition.fetch.bytes = 33554432
rdc.message.max.bytes = 37755000
rdc.compression.type = gzip
rdc.max.request.size = 26214400
rdc.buffer.memory = 524288000
rdc.batch.size = 524288

# destination cluster over writes
ord.max.poll.records = 20000
ord.receive.buffer.bytes = 33554432
ord.send.buffer.bytes = 33554432
ord.max.partition.fetch.bytes = 33554432
ord.message.max.bytes = 37755000
ord.compression.type = gzip
ord.max.request.size = 26214400
ord.buffer.memory = 524288000
ord.batch.size = 524288

topics.blacklist=.*[\-\.]internal, .*\.replica, __consumer_offsets
groups.blacklist=console-consumer-.*, connect-.*, __.*

```

## Launching MM2 Manually

export KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8095:/data01/jmx_exporter/kafka-connect.yaml && \
/data01/kafka/bin/connect-mirror-maker.sh /data01/configs/mm2-data-replication.properties

## Setting up MM2 as Service

vi /etc/systemd/system/kafka-mirror-maker.service

```
[Unit]
Description=Setup Kafka Mirror Maker Service

[Service]
User=root
Group=root
Environment="KAFKA_OPTS=-javaagent:/data01/jmx_exporter/jmx_prometheus_javaagent-0.15.0.jar=8095:/data01/jmx_exporter/kafka-connect.yaml"
ExecStart=/data01/kafka/bin/connect-mirror-maker.sh /data01/configs/mm2-data-replication.properties
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```









cd /data01/docker/

vi docker-compose-kafka-monitoring-tools.yaml

```
version: '3.5'

networks:
  kafka_cluster:
    driver: bridge

services:
  zoonavigator:
    image: elkozmon/zoonavigator:latest
    container_name: zoonavigator
    hostname: zoonavigator
    networks: 
      - kafka_cluster
    environment:
      HTTP_PORT: 8000
    restart: unless-stopped
    ports:
      - "8000:8000"

  cmak:
    image: ashokkumarchoppadandi/cmak:3.0.0.5
    container_name: cmak
    hostname: cmak
    networks: 
      - kafka_cluster
    environment:
      ZK_HOSTS: node101.dev.hdp.kafka.cnvr.net:12181
    restart: always
    ports:
      - "8080:8080"

  prometheus:
    image: ashokkumarchoppadandi/prometheus:2.32.1
    container_name: prometheus
    hostname: prometheus
    networks: 
      - kafka_cluster
    environment:
      PROMETHEUS_HOME: /usr/local/prometheus
      PROMETHEUS_HOST: prometheus
      PROMETHEUS_CONFIG_FILE: "/usr/local/prometheus/prometheus.yml"
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/usr/local/prometheus/prometheus.yml:ro

  mysql-grafana:
    image: ashokkumarchoppadandi/mysql:8
    container_name: mysql-grafana
    networks:
      - kafka_cluster
    hostname: mysql-grafana
    environment:
      MYSQL_ROOT_PASSWORD: Password@123
      MYSQL_DATABASE: grafana

  grafana:
    image: ashokkumarchoppadandi/grafana:8.3.4
    container_name: grafana
    hostname: grafana
    networks: 
      - kafka_cluster
    depends_on:
      - mysql-grafana
    environment:
      DEFAULT_ADMIN_USER: admin
      DEFAULT_ADMIN_PASSWORD: admin
      HTTP_PORT: 3000
      DATABASE_TYPE: mysql
      DATABASE_HOST: "mysql-grafana:3306"
      DATABASE_NAME: grafana
      DATABASE_USER: grafana
      DATABASE_PASSWORD: grafana
    restart: always
    ports:
      - "3000:3000"

```

vi prometheus.yaml

```
global:
  scrape_interval: 5s
  evaluation_interval: 15s
  external_labels:
    monitor: 'cluster'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9090'] ## IP Address of the localhost

  - job_name: 'RDC Zookeeper'
    static_configs:
      - targets: ['node001.dev.dpl.kafka.cnvr.net:8090']
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.*):8090"
        target_label: instance
        replacement: '${1}'

  - job_name: 'ORD Zookeeper'
    static_configs:
      - targets: ['node004.dev.dpl.kafka.cnvr.net:8090']
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.*):8090"
        target_label: instance
        replacement: '${1}'

  - job_name: 'RDC Kafka Cluster'
    static_configs:
      - targets: ['node001.dev.dpl.kafka.cnvr.net:8095', 'node002.dev.dpl.kafka.cnvr.net:8095', 'node003.dev.dpl.kafka.cnvr.net:8095']
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.*):8095"
        target_label: instance
        replacement: '${1}'
  
  - job_name: 'ORD Kafka Cluster'
    static_configs:
      - targets: ['node004.dev.dpl.kafka.cnvr.net:8095', 'node005.dev.dpl.kafka.cnvr.net:8095', 'node006.dev.dpl.kafka.cnvr.net:8095']
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.*):8095"
        target_label: instance
        replacement: '${1}'

  - job_name: 'Mirror Maker 2.0'
    static_configs:
      - targets: ['node007.dev.dpl.kafka.cnvr.net:8095']
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.*):8095"
        target_label: instance
        replacement: '${1}'

  - job_name: 'Mirror Maker 1.0'
    static_configs:
      - targets: ['node007.dev.dpl.kafka.cnvr.net:8090']
    relabel_configs:
      - source_labels: [__address__]
        regex: "(.*):8090"
        target_label: instance
        replacement: '${1}'
```


docker-compose -f docker-compose-kafka-monitoring-tools.yaml up -d

=======================


Produce Messsages Manually:



kafka-topics










node101.ord.adhoc.dw.cnvr.net is alive
node102.ord.adhoc.dw.cnvr.net is alive
node103.ord.adhoc.dw.cnvr.net is alive

bin/kafka-avro-console-consumer --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 --topic avro-topic-2 --property schema.registry.url=http://node005.dev.dpl.kafka.cnvr.net:8081 --from-beginning




bin/kafka-console-producer --broker-list node001.dev.dpl.kafka.cnvr.net:9092,node002.dev.dpl.kafka.cnvr.net:9092,node003.dev.dpl.kafka.cnvr.net:9092 --topic apache-logs





bin/kafka-console-consumer --bootstrap-server node004.dev.dpl.kafka.cnvr.net:9092,node005.dev.dpl.kafka.cnvr.net:9092,node006.dev.dpl.kafka.cnvr.net:9092 --topic apache-logs 