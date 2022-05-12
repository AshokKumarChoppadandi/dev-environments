# Installing SOLR

## System Requirements

Apache Solr runs on Java 8 or greater.

It is also recommended to always use the latest update version of your Java VM, because bugs may affect Solr.

With all Java versions it is strongly recommended to not use experimental -XX JVM options.

CPU, disk and memory requirements are based on the many choices made in implementing Solr (document size, number of documents, and number of hits retrieved to name a few).


## Download Solr

https://solr.apache.org/downloads.html

```
$ wget https://dlcdn.apache.org/lucene/solr/8.11.1/solr-8.11.1.tgz
```

<img src="Solr/SolrDownload.JPG">


## Unpack Solr

```
$ ls solr*

tar -xzvf solr*
```

## Solr Control Script Reference

Solr includes a script known as “bin/solr” that allows you to perform many common operations on your Solr installation or cluster.

You can start and stop Solr, create and delete collections or cores, perform operations on ZooKeeper and check the status of Solr and configured shards.

You can find the script in the bin/ directory of your Solr installation. The bin/solr script makes Solr easier to work with by providing simple commands and options to quickly accomplish common goals.

### Starting and Stopping

```
bin/solr start [options]

bin/solr start -help

bin/solr restart [options]

bin/solr restart -help
```

### Start Parameters

The bin/solr script provides many options to allow you to customize the server in common ways, such as changing the listening port. However, most of the defaults are adequate for most Solr installations, especially when just getting started.

```
-a "<string>"
```

Example:

```
bin/solr start -a "-Xdebug -Xrunjdwp:transport=dt_socket, server=y,suspend=n,address=1044"
```

```
-cloud
```

Start Solr in SolrCloud mode, which will also launch the embedded ZooKeeper instance included with Solr.

This option can be shortened to simply -c.

If you are already running a ZooKeeper ensemble that you want to use instead of the embedded (single-node) ZooKeeper, you should also either specify ZK_HOST in solr.in.sh/solr.in.cmd (see instructions) or pass the -z parameter.

Example: 

```
bin/solr start -c 
    or
bin/solr start -cloud
    or
bin/solr start -cloud -z localhost:2181
```

```
-d <dir>
```

Define a server directory, defaults to server (as in, $SOLR_HOME/server). It is uncommon to override this option. When running multiple instances of Solr on the same host, it is more common to use the same server directory for each instance and use a unique Solr home directory using the -s option.

Example:

```
bin/solr start -d newServerDir
```

```
-e <name>
```

Start Solr with an example configuration. These examples are provided to help you get started faster with Solr generally, or just try a specific feature.

The available options are:

- cloud
- techproducts
- dih
- schemaless

Example:

```
bin/solr start -e schemaless
```

```
-f
```

Start Solr in the foreground; you cannot use this option when running examples with the -e option.

Example:

```
bin/solr start -f
```

```
-h <hostname>
```

Start Solr with the defined hostname. If this is not specified, 'localhost' will be assumed.

Example: 

```
bin/solr start -h search.mysolr.com
```

```
-m <memory>
```

Start Solr with the defined value as the min (-Xms) and max (-Xmx) heap size for the JVM.

Example:

```
bin/solr start -m 1g
```

```
-noprompt
```

Start Solr and suppress any prompts that may be seen with another option. This would have the side effect of accepting all defaults implicitly.

Example: 

```
bin/solr start -e cloud -noprompt
```

```
-p <port>
```

Start Solr on the defined port. If this is not specified, '8983' will be used.

Example:

```
bin/solr start -p 8655
```

```
-s <dir>
```

Sets the solr.solr.home system property; Solr will create core directories under this directory. This allows you to run multiple Solr instances on the same host while reusing the same server directory set using the -d parameter.

If set, the specified directory should contain a solr.xml file, unless solr.xml exists in ZooKeeper. The default value is server/solr.

Example: 

```
bin/solr start -s newHome
```

```
-v
```

Be more verbose. This changes the logging level of log4j from INFO to DEBUG, having the same effect as if you edited log4j2.xml accordingly.

Example: 

```
bin/solr start -f -v
```

```
-q
```

Be more quiet. This changes the logging level of log4j from INFO to WARN, having the same effect as if you edited log4j2.xml accordingly. This can be useful in a production setting where you want to limit logging to warnings and errors.

Example: 

```
bin/solr start -f -q
```

```
-V
```

Start Solr with verbose messages from the start script.

Example:

```
bin/solr start -V
```

```
-z <zkHost>
```

Start Solr with the defined ZooKeeper connection string. This option is only used with the -c option, to start Solr in SolrCloud mode. If ZK_HOST is not specified in solr.in.sh/solr.in.cmd and this option is not provided, Solr will start the embedded ZooKeeper instance and use that instance for SolrCloud operations.

Example: 

```
bin/solr start -c -z server1:2181,server2:2181
```

```
-force
```

If attempting to start Solr as the root user, the script will exit with a warning that running Solr as "root" can cause problems. It is possible to override this warning with the -force parameter.

Example: 

```
sudo bin/solr start -force
```

### SolrCloud Mode

The -c and -cloud options are equivalent:

```
bin/solr start -c

bin/solr start -cloud
```

If you specify a ZooKeeper connection string, such as `-z 192.168.1.4:2181`, then Solr will connect to ZooKeeper and join the cluster.

If you have defined ZK_HOST in `solr.in.sh/solr.in.cmd` (see instructions) you can omit `-z <zk host string>` from all bin/solr commands.
When starting Solr in SolrCloud mode, if you do not define `ZK_HOST` in `solr.in.sh`/`solr.in.cmd` nor specify the `-z` option, then Solr will launch an embedded ZooKeeper server listening on the Solr port + 1000, i.e., if Solr is running on port 8983, then the embedded ZooKeeper will be listening on port 9983.

If your ZooKeeper connection string uses a `chroot`, such as `localhost:2181/solr`, then you need to create the `/solr` znode before launching SolrCloud using the `bin/solr` script.

To do this use the mkroot command outlined below, for example: 
```
bin/solr zk mkroot /solr -z 192.168.1.4:2181
```

### Stop Parameters

```
-p <port>
```
Stop Solr running on the given port. If you are running more than one instance, or are running in SolrCloud mode, you either need to specify the ports in separate requests or use the -all option.

Example: 

```
bin/solr stop -p 8983
```

```
-all
```

Stop all running Solr instances that have a valid PID.

Example: 

```
bin/solr stop -all
```

```
-k <key>
```

Stop key used to protect from stopping Solr inadvertently; default is `"solrrocks"`.

Example: 

```
bin/solr stop -k solrrocks
```

### System Information

#### Version

```
bin/solr version
```

#### Status

```
bin/solr status
```

### Healthcheck

The healthcheck command generates a JSON-formatted health report for a collection when running in SolrCloud mode. The health report provides information about the state of every replica for all shards in a collection, including the number of committed documents and its current state.

```
bin/solr healthcheck [options]

bin/solr healthcheck -help
```

#### Healthcheck Parameters

```
-c <collection>
```

Name of the collection to run a healthcheck against (required).

Example: 

```
bin/solr healthcheck -c gettingstarted
```

```
-z <zkhost>
```

Unnecessary if ZK_HOST is defined in solr.in.sh or solr.in.cmd.

Example: 

```
bin/solr healthcheck -z localhost:2181
```

Below is an example healthcheck request and response using a non-standard ZooKeeper connect string, with 2 nodes running:

```
$ bin/solr healthcheck -c gettingstarted -z localhost:9865
```

## Solr Configuration files

### Solr Home

The home directory contains important configuration information and is the place where Solr will store its index. The layout of the home directory will look a little different when you are running Solr in standalone mode vs. when you are running in SolrCloud mode.

The crucial parts of the Solr home directory are shown in these examples:

*Standalone Mode:*

```
<solr-home-directory>/
   solr.xml
   core_name1/
      core.properties
      conf/
         solrconfig.xml
         managed-schema
      data/
   core_name2/
      core.properties
      conf/
         solrconfig.xml
         managed-schema
      data/
```

*SolrCloud Mode:*

```
<solr-home-directory>/
   solr.xml
   core_name1/
      core.properties
      data/
   core_name2/
      core.properties
      data/
```

### Configuration files

Inside Solr’s Home, you’ll find these files:

- solr.xml specifies configuration options for your Solr server instance
- Per Solr Core:
    - *`core.properties`* defines specific properties for each core such as its name, the collection the core belongs to, the location of the schema, and other parameters
    - *`solrconfig.xml`* controls high-level behavior. You can, for example, specify an alternate location for the data directory.
    - *`managed-schema`* (or *`schema.xml`* instead) describes the documents you will ask Solr to index. The Schema define a document as a collection of fields. You get to define both the field types and the fields themselves. Field type definitions are powerful and include information about how Solr processes incoming field values and query values.
    - *`data/`* The directory containing the low level index files.

## Taking Solr to Production

### Service Installation Script

Solr includes a service installation script (`bin/install_solr_service.sh`) to help you install Solr as a service on Linux

### Planning Your Directory Structure

We recommend separating your live Solr files, such as logs and index files, from the files included in the Solr distribution bundle, as that makes it easier to upgrade Solr and is considered a good practice to follow as a system administrator.

### Solr Installation Directory
By default, the service installation script will extract the distribution archive into `/opt`. You can change this location using the ***`-i`*** option when running the installation script. The script will also create a symbolic link to the versioned directory of Solr.

### Separate Directory for Writable Files
You should also separate writable Solr files into a different directory; by default, the installation script uses `/var/solr`, but you can override this location using the ***`-d`*** option. With this approach, the files in `/opt/solr` will remain untouched and all files that change while Solr is running will live under `/var/solr`.

### Create the Solr User

Running Solr as ***`root`*** is not recommended for security reasons, and the control script `(bin/solr)` start command will refuse to do so. Consequently, you should determine the username of a system user that will own all of the Solr files and the running Solr process. By default, the installation script will create the `solr` user, but you can override this setting using the ***`-u`*** option. 

If your organization has specific requirements for creating new user accounts, then you should create the user before running the script. The installation script will make the Solr user the owner of the `/opt/solr` and `/var/solr` directories.

### Solr Home Directory

The Solr home directory (not to be confused with the Solr installation directory) is where Solr manages core directories with index files. By default, the installation script uses `/var/solr/data`. If the ***`-d`*** option is used on the install script, then this will change to the data subdirectory in the location given to the ***`-d`*** option.

If you do not store `solr.xml` in ZooKeeper, the home directory must contain a `solr.xml` file. When Solr starts up, the Solr Control Script passes the location of the home directory using the `-Dsolr.solr.home=…​` system property.

### Environment Overrides Include File

The service installation script creates an environment specific include file `(/etc/default/solr.in.sh)` that overrides defaults used by the `bin/solr` script. The main advantage of using an include file is that it provides a single location where all of your environment-specific overrides are defined. If you used the ***`-s`*** option on the install script to change the name of the service, then the first part of the filename will be different. For a service named `solr-demo`, the file will be named `/etc/default/solr-demo.in.sh`. There are many settings that you can override using this file. However, at a minimum, this script needs to define the `SOLR_PID_DIR` and `SOLR_HOME` variables, such as:

```
SOLR_PID_DIR=/var/solr
SOLR_HOME=/var/solr/data
```

### Log Settings

Solr uses Apache Log4J for logging. The installation script copies `/opt/solr/server/resources/log4j2.xml` to `/var/solr/log4j2.xml`. It is configured to send logs to the correct location by checking the following settings in `/etc/default/solr.in.sh`:

```
LOG4J_PROPS=/var/solr/log4j2.xml
SOLR_LOGS_DIR=/var/solr/logs
```

### init.d Script

When running a service like Solr on Linux, it’s common to setup an `init.d` script so that system administrators can control Solr using the service tool, such as: `service solr start`. The installation script creates a very basic `init.d` script to help you get started. If you used the ***`-s`*** option on the install script to change the name of the service, then the filename will be different. Notice that the following variables are setup for your environment based on the parameters passed to the installation script:

```
SOLR_INSTALL_DIR=/opt/solr
SOLR_ENV=/etc/default/solr.in.sh
RUNAS=solr
```

The `SOLR_INSTALL_DIR` and `SOLR_ENV` variables should be self-explanatory. The `RUNAS` variable sets the owner of the Solr process, such as solr; if you don’t set this value, the script will run Solr as `root`, which is not recommended for production. You can use the `/etc/init.d/solr` script to start Solr by doing the following as root:

```
service solr start
```

The `/etc/init.d/solr` script also supports the `stop`, `restart`, and `status` commands. Please keep in mind that the init script that ships with Solr is very basic and is intended to show you how to setup Solr as a service. Also, the installation script sets the Solr service to start automatically when the host machine initializes.

### Progress Check

Specifically, you should be able to control Solr using `/etc/init.d/solr`. Please verify the following commands work with your setup:

```
sudo service solr restart
sudo service solr status
```

The status command should give some basic information about the running Solr node that looks similar to:

```
Solr process PID running on port 8983
{
  "version":"5.0.0 - ubuntu - 2014-12-17 19:36:58",
  "startTime":"2014-12-19T19:25:46.853Z",
  "uptime":"0 days, 0 hours, 0 minutes, 8 seconds",
  "memory":"85.4 MB (%17.4) of 490.7 MB"}
```

If the status command is not successful, look for error messages in `/var/solr/logs/solr.log`

## Fine-Tune Your Production Setup

### Dynamic Defaults for ConcurrentMergeScheduler

The Merge Scheduler is configured in `solrconfig.xml` and defaults to `ConcurrentMergeScheduler`. This scheduler uses multiple threads to merge Lucene segments in the background.

By default, the `ConcurrentMergeScheduler` auto-detects whether the underlying disk drive is `rotational` or a `SSD` and sets defaults for `maxThreadCount` and `maxMergeCount` accordingly. If the disk drive is determined to be rotational then the `maxThreadCount` is set to **`1`** and `maxMergeCount` is set to **`6`**. Otherwise, `maxThreadCount` is set to **`4`** or half the number of processors available to the JVM whichever is greater and `maxMergeCount` is set to `maxThreadCount+5`.

This auto-detection works only on Linux and even then it is not guaranteed to be correct. On all other platforms, the disk is assumed to be rotational. Therefore, if the auto-detection fails or is incorrect then indexing performance can suffer badly due to the wrong defaults.

The auto-detected value is exposed by the Metrics API with the key `solr.node:CONTAINER.fs.coreRoot.spins`. A value of `true` denotes that the disk is detected to be a rotational or spinning disk.

It is safer to explicitly set values for `maxThreadCount` and `maxMergeCount` in the IndexConfig section of `SolrConfig.xml` so that values appropriate to your hardware are used.

Alternatively, the boolean system property `lucene.cms.override_spins` can be set in the `SOLR_OPTS` variable in the include file to override the auto-detected value. Similarly, the system property `lucene.cms.override_core_count` can be set to the number of CPU cores to override the auto-detected processor count.

### Memory and GC Settings

By default, the `bin/solr` script sets the maximum Java heap size to `512M` (`-Xmx512m`), which is fine for getting started with Solr. For production, you’ll want to increase the maximum heap size based on the memory requirements of your search application; values between **`8`** and **`16`** gigabytes are not uncommon for production servers. When you need to change the memory settings for your Solr server, use the `SOLR_HEAP` variable in the include file, such as:

```
SOLR_HEAP="8g"
```

### Out-of-Memory Shutdown Hook

The `bin/solr` script registers the `bin/oom_solr.sh` script to be called by the JVM if an `OutOfMemoryError` occurs. The `oom_solr.sh` script will issue a `kill -9` to the Solr process that experiences the `OutOfMemoryError`. This behavior is recommended when running in SolrCloud mode so that ZooKeeper is immediately notified that a node has experienced a non-recoverable error.

### Going to Production with SolrCloud

To run Solr in `SolrCloud` mode, you need to set the `ZK_HOST` variable in the include file to point to your ZooKeeper ensemble. Running the embedded ZooKeeper is not supported in production environments. For instance, if you have a ZooKeeper ensemble hosted on the following three hosts on the default client port 2181 (zk1, zk2, and zk3), then you would set:

```
ZK_HOST=zk1,zk2,zk3
```

When the `ZK_HOST` variable is set, Solr will launch in `"cloud"` mode.

#### ZooKeeper chroot

If you’re using a ZooKeeper instance that is shared by other systems, it’s recommended to isolate the SolrCloud `znode` tree using ZooKeeper’s chroot support. For instance, to ensure all znodes created by SolrCloud are stored under `/solr`, you can put `/solr` on the end of your `ZK_HOST` connection string, such as:

```
ZK_HOST=zk1,zk2,zk3/solr
```

Before using a chroot for the first time, you need to create the root path (znode) in ZooKeeper by using the Solr Control Script. We can use the `mkroot` command for that:

```
bin/solr zk mkroot /solr -z <ZK_node>:<ZK_PORT>
```

If you also want to bootstrap ZooKeeper with existing `solr_home`, you can instead use the `zkcli.sh` / `zkcli.bat` bootstrap command, which will also create the chroot path if it does not exist. See Command Line Utilities for more info.

#### Solr Hostname

Use the `SOLR_HOST` variable in the include file to set the hostname of the Solr server.

```
SOLR_HOST=solr1.example.com
```

Setting the hostname of the Solr server is recommended, especially when running in SolrCloud mode, as this determines the address of the node when it registers with ZooKeeper.

### Environment Banner in Admin UI

To guard against accidentally doing changes to the wrong cluster, you may configure a visual indication in the Admin UI of whether you currently work with a production environment or not. To do this, edit your `solr.in.sh` or `solr.in.cmd` file with a `-Dsolr.environment=prod` setting, or set the cluster property named environment. To specify label and/or color, use a comma-delimited format as below. The + character can be used instead of space to avoid quoting. Colors may be valid CSS colors or numeric, e.g., #ff0000 for bright red. Examples of valid environment configs:

- prod
- test,label=Functional+test
- dev,label=MyDev,color=blue
- dev,color=blue

### Override Settings in solrconfig.xml

Solr allows configuration properties to be overridden using Java system properties passed at startup using the `-Dproperty=value` syntax. For instance, in `solrconfig.xml`, the default auto soft commit settings are set to:
```
<autoSoftCommit>
  <maxTime>${solr.autoSoftCommit.maxTime:-1}</maxTime>
</autoSoftCommit>
```

In general, whenever you see a property in a Solr configuration file that uses the `${solr.PROPERTY:DEFAULT_VALUE}` syntax, then you know it can be overridden using a Java system property. For instance, to set the maxTime for soft-commits to be 10 seconds, then you can start Solr with `-Dsolr.autoSoftCommit.maxTime=10000`, such as:

```
bin/solr start -Dsolr.autoSoftCommit.maxTime=10000
```

The `bin/solr` script simply passes options starting with **`-D`** on to the JVM during startup. For running in production, we recommend setting these properties in the `SOLR_OPTS` variable defined in the include file. Keeping with our soft-commit example, in `/etc/default/solr.in.sh`, you would do:

```
SOLR_OPTS="$SOLR_OPTS -Dsolr.autoSoftCommit.maxTime=10000"
```

### Ulimit Settings

Current Ulimit values can be listed with the following command:

```
ulimit -a
```

These four settings in particular are important to have set *`very high`*, *`unlimited`* if possible.

max processes (*`ulimit -u`*): *`65,000`* is the recommended minimum.

file handles (*`ulimit -n`*): *`65,000`* is the recommended minimum. All the files used by all replicas have their file handles open at once so this can grow quite large.

virtual memory (*`ulimit -v`*): Set to *`unlimited`*. This is used to by MMapping the indexes.

max memory size (*`ulimit -m`*): Also used by MMap, set to *`unlimited`*.

If your system supports it, *`sysctl vm.max_map_count`*, should be set to unlimited as well.

##### Setting ulimit -n to unlimited

vi /etc/security/limits.conf

*    soft    nofile 100000
*    hard    nofile 100000

### Avoid Swapping (*nix Operating Systems)

When running a Java application like Lucene/Solr, having the OS swap memory to disk is a very bad situation. We usually prefer a hard crash so other healthy Solr nodes can take over, instead of letting a Solr node swap, causing terrible performance, timeouts and an unstable system. So our recommendation is to disable swap on the host altogether or reduce the `"swappiness"`. These instructions are valid for Linux environments. Also note that when running Solr in a Docker container, these changes must be applied to the host.

#### Disabling Swap

To disable swap on a Linux system temporarily, you can run the `swapoff` command:

```
sudo swapoff -a
```

If you want to make this setting permanent, first make sure you have more than enough physical RAM on your host and then consult the documentation for your Linux system for the correct procedure to disable swap.

#### Reduce Swappiness

An alternative option is to reduce the `"swappiness"` of your system. A Linux system will by default be quite aggressive in swapping out memory to disk, by having a high default `"swappiness"` value. By reducing this to a very low value, it will have almost the same effect as using `swapoff`, but Linux will still be allowed to swap in case of emergency. To check the current swappiness setting, run:

```
cat /proc/sys/vm/swappiness
```

Next, to change the setting permanently, open `/etc/sysctl.conf` as the `root` user. Then, change or add this line to the file:

```
vm.swappiness = 1
```

Alternatively, you can change the setting temporarily by running this comamnd:

```
echo 1 > /proc/sys/vm/swappiness
```

### NOTE: 

- Choosing Memory Heap Settings 
- GC_TUNE variable in the /etc/default/solr.in.sh
- solrconfig.xml (maxThreadCount and maxMergeCount)


