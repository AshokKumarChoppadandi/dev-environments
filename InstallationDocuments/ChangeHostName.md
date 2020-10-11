# Changing the Host Name of a CentOS 7 VM

### 1. Login to the Terminal, Switch the ROOT User & Check the Hostname:

``` 
su

hostname

hostname -f
``` 
 
### 2. Set the New Hostname:

```
hostnamectl set-hostname <NEW HOSTNAME>
```

***Example:***

```
hostnamectl set-hostname zookeeperbroker1.com
```

### 3. Verify Hostname

