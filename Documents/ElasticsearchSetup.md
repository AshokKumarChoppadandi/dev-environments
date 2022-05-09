# Elasticsearch Setup

## Pre-requisites

- Java 11 is needed for Elasticsearch 7.x
- set vm.max_map_count=262144

### Installing Java

```
sudo dnf install java-11-openjdk-devel -y 
```

### Setting JAVA_HOME in /etc/profile

```
vi /etc/profile
```

```
# Setting JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java
export PATH=$PATH:$JAVA_HOME/bin
```

```
source /etc/profile
```

### Setting vm.max_map_count

```
sudo vi /etc/sysctl.conf
```

```
vm.max_map_count=262144
```

### Disable the firewall

```

```

## Installing Elasticsearch

### Downloading Elasticsearch

```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz
```

### Extract the tar.gz file

```
sudo tar -xzvf elasticsearch-7.17.0-linux-x86_64.tar.gz -C /usr/local/
```

### Create Soft Link

```
 sudo ln -s /usr/local/elasticsearch-7.17.0 /usr/local/elasticsearch
```

### Change the Owner of Elasticsearch Home directory

```
sudo chown bigdata:bigdata -R /usr/local/elasticsearch*
```

### Set the JVM options

```
vi /usr/local/elasticsearch/config/jvm.options
```

```
-Xms2g
-Xmx2g
```

### Configure the Elasticsearch Properties

```
sudo vi /usr/local/elasticsearch/config/elasticsearch.yml
```

```
cluster.name: my-local-es-cluster
node.name: node-1
node.master: true
node.attr.rack: r1
path.data: /usr/local/elasticsearch/data
path.logs: /usr/local/elasticsearch/logs
bootstrap.memory_lock: false
network.host: 0.0.0.0
http.port: 9200
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
cluster.initial_master_nodes: ["node-1"]
```

### Setting ES_HOME

```
sudo vi /etc/profile
```

```
# Setting ES_HOME
export ES_HOME=/usr/local/elasticsearch
export PATH=$PATH:$ES_HOME/bin
```

### Set the ulimits to unlimited

```
sudo vi /etc/security/limits.conf
```

```
*       soft    noproc  unlimited
*       hard    noproc  unlimited
```

### Starting Elasticsearch

```
elasticsearch -d
```

## Installing Kibana

### Downloading Kibana

```
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.17.0-linux-x86_64.tar.gz
```

### Extract Kibana

```
sudo tar -xzvf kibana-7.17.0-linux-x86_64.tar.gz -C /usr/local/
```

### Create Soft Link

```
sudo ln -s /usr/local/kibana-7.17.0-linux-x86_64 /usr/local/kibana
```

### Change the owner of Kibana Home Directory

```
sudo chown bigdata:bigdata -R /usr/local/kibana*

ll /usr/local/
```

### Configure kibana.yaml

```
vi /usr/local/kibana/config/kibana.yml
```

```
server.port: 5601
server.host: 0.0.0.0
server.name: "my-local-kibana"
elasticsearch.hosts: ["http://localhost:9200"]
kibana.index: ".kibana"
kibana.defaultAppId: "home"
```

### Setting KIBANA_HOME

```
sudo vi /etc/profile
```

```
# Setting ES_HOME
export KIBANA_HOME=/usr/local/kibana
export PATH=$PATH:$ES_HOME/bin
```