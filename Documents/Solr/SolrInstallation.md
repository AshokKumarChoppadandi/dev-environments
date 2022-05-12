# Installing Solr on CentOS 7

## Update the OS

```
sudo yum update -y
```

## Install Open JDK 8

```
sudo yum install java-1.8.0-openjdk-devel -y
```

## Set JAVA_HOME

`sudo vi /etc/profile`

```
export JAVA_HOME=/usr/lib/jvm/java
export PATH=$PATH:$JAVA_HOME/bin
```

`source /etc/profile`

## Disable Swappiness

To check the swappiness:

```
cat /proc/sys/vm/swappiness
```

To set it to minimum:

`sudo vi /etc/sysctl.conf`

```
# sysctl settings are defined through files in
# /usr/lib/sysctl.d/, /run/sysctl.d/, and /etc/sysctl.d/.
#
# Vendors settings live in /usr/lib/sysctl.d/.
# To override a whole file, create a new file with the same in
# /etc/sysctl.d/ and put new settings there. To override
# only specific settings, add a file with a lexically later
# name in /etc/sysctl.d/ and put new settings there.
#
# For more information, see sysctl.conf(5) and sysctl.d(5).

vm.swappiness=1

```

## Solr User

Create Solr user:

```
sudo useradd solr
```

Create Password for Solr user:

```
sudo passwd solr
```

Granting Sudo permissions to the Solr user:

```
sudo usermod -aG wheel solr
```

## Increase ulimits

To get the default or configured ulimit, the folliwing is the command"

```
# ulimit -a

core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 63446
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 4096
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

### nproc / max processes:

```
ulimit -u

4096
```

Set to the highest value or unlimited for solr user:

`sudo vi /etc/security/limits.d/20-nproc.conf`

```
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

*          soft    nproc     4096
root       soft    nproc     unlimited
solr       soft    nproc     unlimited
solr       hard    nproc     unlimited
```

### nofile / file handles:

```
ulimit -n

1024
```

Set to the highest value or unlimited for solr user:

`sudo vi /etc/security/limits.conf`

```
solr       soft    nofile     100000
solr       hard    nofile     100000
```

NOTE: The max value for nofile should be less than the value in `cat /proc/sys/fs/nr_open` i.e., **`1048576`**

### virtual memory:

```
ulimit -v

unlimited
```

### max memory size:

```
ulimit -m

unlimited
```

### max_map_count:

`sudo vi /etc/sysctl.conf`

```
# sysctl settings are defined through files in
# /usr/lib/sysctl.d/, /run/sysctl.d/, and /etc/sysctl.d/.
#
# Vendors settings live in /usr/lib/sysctl.d/.
# To override a whole file, create a new file with the same in
# /etc/sysctl.d/ and put new settings there. To override
# only specific settings, add a file with a lexically later
# name in /etc/sysctl.d/ and put new settings there.
#
# For more information, see sysctl.conf(5) and sysctl.d(5).

vm.swappiness=1
vm.max_map_count=262144
```

### Install lsof 

```
sudo yum install lsof -y
```

### Disable Firewall

```
sudo systemctl status firewalld.service
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
```

### Add Zookeeper hosts to /etc/hosts of Solr host

`sudo vi /etc/hosts`

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.0.151   node101.bigdata.com
```

### Installing Solr

Download Solr:

```
wget https://dlcdn.apache.org/lucene/solr/8.11.1/solr-8.11.1.tgz
```

Extract Solr:

```
tar -xzvf solr-8.11.1.tgz
```

Create solr chroot in Zookeeper Quorum:

```
cd solr-8.11.1/

bin/solr zk mkroot /solr -z node101.bigdata.com:3181
```

Upload the solr.xml file to chroot in Zookeeper

```
bin/solr zk cp file:/home/bigdata/solr-8.11.1/server/solr/solr.xml zk:/solr/ -z node101.bigdata.com:3181
```

### Install Solr:

```
sudo bin/install_solr_service.sh -help

sudo bin/install_solr_service.sh solr-8.11.0.tgz -i /opt -d /var/test-solr -u solr -s test-solr -p 8983

sudo bin/install_solr_service.sh solr-8.11.0.tgz -i /opt -d /var/test-solr -u solr -s test-solr -p 8983
```

### Set environment variables in include file `solr.in.sh`:

`vi /etc/default/test-solr.in.sh`

```
RUNAS=solr
SOLR_INSTALL_DIR=/opt/test-solr
SOLR_JAVA_HOME=${JAVA_HOME}
SOLR_STOP_WAIT="180"
SOLR_START_WAIT="$SOLR_STOP_WAIT"
SOLR_HEAP="8g"
ZK_HOST="node101.bigdata.com:3181/solr"
SOLR_HOST="node103.bigdata.com"
SOLR_WAIT_FOR_ZK="30"
SOLR_TIMEZONE="UTC"
ENABLE_REMOTE_JMX_OPTS="false"
RMI_PORT=18983
SOLR_PID_DIR=/var/test-solr
SOLR_HOME=/var/test-solr
SOLR_DATA_HOME=/var/test-solr/data
LOG4J_PROPS=/var/test-solr/log4j2.xml
SOLR_LOG_LEVEL=INFO
SOLR_LOGS_DIR=/var/test-solr/logs
SOLR_LOG_PRESTART_ROTATION=false
SOLR_REQUESTLOG_ENABLED=false
SOLR_PORT=8983
SOLR_IP_WHITELIST=192.168.0.0/24
SOLR_OPTS="$SOLR_OPTS -Dsolr.environment=dev,label=MyDev,color=blue"
```


NOTE: The fields file `solr.in.sh` will be created by the installation script (./install_solr_service.sh) at location `/etc/default/solr.in.sh`. The name is given based on the service name as follows:

```
sudo bin/install_solr_service.sh solr-8.11.0.tgz -i /opt -d /var/test-solr -u solr -s `<SERVICE NAME>` -p 8983
```

Then the include file name will be `test-solr.in.sh`


### Check the Solr Service status

```
sudo service solr status
```

### Stop the Solr Service

```
sudo service solr stop
```

### Restart the Solr Service

```
sudo service solr restart
```

