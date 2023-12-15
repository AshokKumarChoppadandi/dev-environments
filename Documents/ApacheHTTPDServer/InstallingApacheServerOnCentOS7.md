# Setting up Apache HTTPD Server On CentOS 7

#### Pre-requisites

* Root privileges
* Access to Internet
* Web Browser

### Root Login to Server via SSH

```
ssh root@192.168.0.115
```

<img src="../Screenshots/HTTPDServer/1SSHLogin.png">

### Update Packages

```
yum update -y
```

<img src="../Screenshots/HTTPDServer/2YumUpdate1.png">

<img src="../Screenshots/HTTPDServer/2YumUpdate2.png">

### Install Apache `httpd` Server

```
yum install httpd -y
```

<img src="../Screenshots/HTTPDServer/3YumInstallApacheServer.png">

### Apache httpd Server default Home & Document directory

<img src="../Screenshots/HTTPDServer/4ApacheServerHomeDirectory.png">

### Configuring Listening Port and Document Directory

```
cat /etc/httpd/conf/httpd.conf
```

```
#
# Listen: Allows you to bind Apache to specific IP addresses and/or
# ports, instead of the default. See also the <VirtualHost>
# directive.
#
# Change this to Listen on specific IP addresses as shown below to
# prevent Apache from glomming onto all bound IP addresses.
#
#Listen 12.34.56.78:80
Listen 80
```

<img src="../Screenshots/HTTPDServer/5ListenPort.png">

```
#
# DocumentRoot: The directory out of which you will serve your
# documents. By default, all requests are taken from this directory, but
# symbolic links and aliases may be used to point to other locations.
#
DocumentRoot "/var/www/html"
```

<img src="../Screenshots/HTTPDServer/6DocumentRootFolder.png">

### Create a Sample HTML File

```
cat > /var/www/html/index.html
```

```
Hello World!!!

This is the message from Apache Server running on CentOS 7 Virtual Machine
```

<img src="../Screenshots/HTTPDServer/7CreateIndexHTML.png">

### Start & Enable Apache `httpd` Server

```
systemctl status httpd.service
```

```
systemctl start httpd.service
```

```
systemctl enable httpd.service
```

```
systemctl status httpd.service
```

<img src="../Screenshots/HTTPDServer/8StartAndEnableApacheServer.png">

### Adding Firewall Rule to allow http & https requests

```
firewall-cmd --permanent --add-service=http
```

```
firewall-cmd --permanent --add-service=https
```

<img src="../Screenshots/HTTPDServer/9AllowHTTPRequestsFromFirewall.png">

### Accessing the Web Page

From Browser:

<img src="../Screenshots/HTTPDServer/10AccessWebPageFromBrowser.png">

Using CURL:

```
curl http://192.168.0.115
```

<img src="../Screenshots/HTTPDServer/11AccessWebPageUsingCURL.png">