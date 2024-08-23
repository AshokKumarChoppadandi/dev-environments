# Hadoop Installation

## Pre-requisites

* Sudo User with NO Password
* Static IP
* Update ALL packages
* JDK 8

## Design Plan

3 Virtual Machines are used for setting up the Hadoop Cluster.

- 1 VM - Namenode, Resource Manager - master1.bigdata.com - 192.168.0.221
- 1 VM - Secondary Namenode, MR History Server - master2.bigdata.com - 192.168.0.222
- 1 VM - Data Node, Node Manager - worker1.bigdata.com - 192.168.0.223

NOTE: Oracle VirtualBox is used to create the CentOS 7 (Minimal) based Virtual Machines.
- CentOS 7 can be downloaded from: https://www.centos.org/download/
- Oracle VirtualBox can be downloaded from: https://www.virtualbox.org/wiki/Downloads

## DNS Resolution

Adding hosts and ip addresses:

```
sudo vi /etc/hosts
```

```
192.168.0.221   master1.bigdata.com
192.168.0.222   master2.bigdata.com
192.168.0.223   worker1.bigdata.com
```

## Set Password Less Login

Generate ssh keys on 3 VMs:

```
ssh-keygen -t rsa
```

Copy SSH Public to the respective server:

```
ssh-copy-id -i ~/.ssh/id_rsa.pub bigdata@master1.bigdata.com
ssh-copy-id -i ~/.ssh/id_rsa.pub bigdata@master2.bigdata.com
ssh-copy-id -i ~/.ssh/id_rsa.pub bigdata@worker1.bigdata.com
```

## Disable Strict Host Checking

```
sudo vi ~/.ssh/ssh-config
```

```
Host *
	UserKnownHostsFile /dev/null
	StrictHostKeyChecking no
```

## Disabling Firewall

```
sudo systemctl status firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

## Install wget

```
sudo yum install wget -y
```
## Download

Hadoop binaries can be download from https://archive.apache.org/dist

```
wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz
```

## Extract 

```
sudo tar -xzvf hadoop-2.7.4.tar.gz -C /usr/local
```

## Creating Soft Link

```
sudo ln -s /usr/local/hadoop-2.7.4 /usr/local/hadoop
```

## Setting HADOOP_HOME

```
sudo vi /etc/profile
```

```
# Setting JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java
export PATH=$PATH:$JAVA_HOME/bin

# Setting HADOOP_HOME
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

## Setting hadoop-env.sh

```
sudo vi /usr/local/hadoop/conf/hadoop-env.sh
```