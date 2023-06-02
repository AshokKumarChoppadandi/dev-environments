# Python 3 Installation on CentOS 8 Stream

## Prerequisites
* `root` or `sudo` privileges

## Installation Steps

### Login to the CentOS 8 Stream Server

```
ssh root@192.168.0.51
```

<img src="Screenshots/Python3SetUp/1Login.jpg">

### Update the OS / Packages

```
dnf update -y
```

<img src="Screenshots/Python3SetUp/2DnfUpdate.jpg">

### Install Python 3.9

```
dnf module install python39 -y
```

<img src="Screenshots/Python3SetUp/3InstallPython.jpg">

<img src="Screenshots/Python3SetUp/4InstallPython.jpg">

### Check Python3 version

```
python3 -V
```

<img src="Screenshots/Python3SetUp/5PythonVersion.jpg">

### Check Atlernatives 

```
alternatives --config python3
```

<img src="Screenshots/Python3SetUp/6Alternatives.jpg">

### Making Python3.9 as default

```
alternatives --config python
```

Select the number assigned to `/usr/bin/python3.9`

<img src="Screenshots/Python3SetUp/6Python3AsDefault.jpg">

### Pip3 Installation

pip3 will be automatically installed while installing the Python 3

To check the pip3 version

```
pip3 --version
```

<img src="Screenshots/Python3SetUp/7Pip3Version.jpg">

Create a soft link to use `pip3` as `pip`

```
ln -s /usr/bin/pip3 /usr/bin/pip

pip --version
```

<img src="Screenshots/Python3SetUp/7Pip3SoftLink.jpg">

### Development Tools installation

To be able to install and build Python modules with pip, you need to install the Development tools:

```
dnf install python3-devel -y
```

<img src="Screenshots/Python3SetUp/8DevToolsInstallation.jpg">
<img src="Screenshots/Python3SetUp/9DevToolsInstallation.jpg">

```
dnf groupinstall 'development tools' -y 
```

<img src="Screenshots/Python3SetUp/10DevToolsInstallation.jpg">
<img src="Screenshots/Python3SetUp/11DevToolsInstallation.jpg">
<img src="Screenshots/Python3SetUp/11DevToolsInstallation.jpg">

***Python3 & Pip3 is successfully setup on CentOS 8 Stream.***
