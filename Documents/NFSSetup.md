# NFS SETUP FOR KUBERNETES VOLUMES

## Pre-requisites

* Linux Server (VM / Remote Server) - CentOS 8 Stream - 192.168.
* Root privileges

## Setup

### Login to CentOS 8 Stream server as `root` user

```
ssh root@192.168.0.51
```

<img src="Screenshots/NFS-Server-Login.jpg">

### Update Packages

```
dnf update -y
```

<img src="Screenshots/NFS-Server-Update.jpg">

### Install `nfs-utils`

```
dnf install nfs-utils -y
```

<img src="Screenshots/NFS-Server-Install-NFSUtils-1.jpg">

<img src="Screenshots/NFS-Server-Install-NFSUtils-2.jpg">

### Start the `nfs-server`

```
systemctl start nfs-server.service
```

### Enable the `nfs-server` to start at boot time

```
systemctl enable nfs-server.service
```

### Check the status of `nfs-server`

```
systemctl status nfs-server.service
```

<img src="Screenshots/NFS-Server-Start.jpg">

### Create the shared directory

```
mkdir -p /mnt/share/data
```

<img src="Screenshots/NFS-Server-MakeSharedDirectory.jpg">

### Change the owner to `nobody` and provide all permissions

```
chown -R nobody: /mnt/share/data/

chmod -R 777 /mnt/share/data/

ls -ltr /mnt/share/
```

<img src="Screenshots/NFS-Server-SharedDirectoryPermissions.jpg">

### Export the shared directory to the nfs clients

#### Add shared directory to `/etc/exports`

```
cat /etc/exports
```

Add the below line to `/etc/exports`

```
/mnt/share/data *(rw,sync,no_subtree_check,no_all_squash,no_root_squash,insecure)
```

<img src="Screenshots/NFS-Server-ExportsFile.jpg">

#### Export shared directory and check the status

```
exportfs -arv

exportfs -s

exportfs
```

<img src="Screenshots/NFS-Server-ExportFS.jpg">

### Allow nfs through the firewall

```
firewall-cmd --permanent --add-service=nfs

firewall-cmd --permanent --add-service=rpc-bind

firewall-cmd --permanent --add-service=mountd

firewall-cmd --reload
```

<img src="Screenshots/NFS-Server-Firewall.jpg">

### Check RPC info

```
rpcinfo -p | grep nfs
```

<img src="Screenshots/NFS-Server-RPCInfo.jpg">


## Now we have an NFS server running with a shared directory at `/mnt/share/data` on ip address `192.168.0.51` which is exposed to the world.

## ***Cheers & Happy Coding...!!!***