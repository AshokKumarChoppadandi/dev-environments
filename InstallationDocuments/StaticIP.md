# How To Set Static IP on a CentOS 7 VM using CLI:

### 1. Login to VM

<img src="Screenshots/CentOS7_VM_Login.JPG">

### 2. Open Terminal and check the IP Address:

<img src="Screenshots/OpenTerminal.JPG">

Use the below command to get the IP Address

	ifconfig

<img src="Screenshots/Initial_IP.JPG">

### 3. Switch to ROOT user
    
    su

<img src="Screenshots/Login_As_Root_User.JPG">

### 4. Get the Nameserver (Your Router) IP address:

	cat /etc/resolv.conf

<img src="Screenshots/NameServer_IP_Address.JPG">

### 5. Configurations needs to be changed in the below file:

	vi /etc/sysconfig/network-scripts/ifcfg-ens33

<img src="Screenshots/vi_ifcfg-ens33.JPG">

Default configuration for the Network:

```	
        TYPE="Ethernet"
        PROXY_METHOD="none"
        BROWSER_ONLY="no"
        BOOTPROTO="dhcp"
        DEFROUTE="yes"
        IPV4_FAILURE_FATAL="no"
        IPV6INIT="yes"
        IPV6_AUTOCONF="yes"
        IPV6_DEFROUTE="yes"
        IPV6_FAILURE_FATAL="no"
        IPV6_ADDR_GEN_MODE="stable-privacy"
        NAME="ens33"
        UUID="6cdcdd24-ec24-49b9-8a74-0c12bac9aeca"
        DEVICE="ens33"
        ONBOOT="yes"
```

<img src="Screenshots/DefaultNetworkConfiguration.JPG">

Change the configuration to below :

```	
        TYPE="Ethernet"
        PROXY_METHOD="none"
        BROWSER_ONLY="no"
        BOOTPROTO="static"
        DEFROUTE="yes"
        IPV4_FAILURE_FATAL="no"
        IPV6INIT="yes"
        IPV6_AUTOCONF="yes"
        IPV6_DEFROUTE="yes"
        IPV6_FAILURE_FATAL="no"
        IPV6_ADDR_GEN_MODE="stable-privacy"
        NAME="ens33"
        UUID="6cdcdd24-ec24-49b9-8a74-0c12bac9aeca"
        DEVICE="ens33"
        ONBOOT="yes"
        IPADDR="192.168.107.102"
        NETMASK="255.255.255.0"
        GATEWAY="192.168.107.2"
        DNS1=8.8.8.8
        DNS2=8.8.4.4
```

<img src="Screenshots/StaticIPConfigration.JPG">

***Note:*** The Gateway should be Nameserver IP Address.
	
### 6. Restart the Network
 
To restart the Network use the below command:

	systemctl restart network

<img src="Screenshots/NetworkRestart.JPG">

### 7. Now check the IP address again:

Use the below command to get the IP address

	ifconfig

<img src="Screenshots/StaticIP.JPG">

### 8. Check your internet connectivity:

	ping google.comm

<img src="Screenshots/InternetConnectivity.JPG">

That's completes setting up the STATIC IP for the CentOS 7 VM.

<img src="Screenshots/Woohoo.jpeg">

Now the STATIC IP for the CentOS 7 VM is configured Properly.