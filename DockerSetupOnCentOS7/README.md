#DOCKER AND DOCKER COMPOSE SETUP ON CENTOS 7

## Pre-requisites

* To install Docker Engine, you need a maintained version of CentOS 7. Archived versions aren’t supported or tested.

* The centos-extras repository must be enabled. This repository is enabled by default, but if you have disabled it, you need to re-enable it.

* The overlay2 storage driver is recommended.

<img src="Screenshots/CentOS_Version.JPG">

* Login as ROOT user

<img src="Screenshots/RootUser.JPG">

* Update the CentOS: `yum update -y`

<img src="Screenshots/YumUpdate.JPG">

## Docker Installation

### Setting up the yum repository for Docker:

Install the yum-utils package (which provides the yum-config-manager utility) and set up the stable repository.

```
yum install -y yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

```

<img src="Screenshots/YumUtils.JPG">

<img src="Screenshots/AddingDockerRepo.JPG">

### Install Docker Engine:

* Install the latest version of Docker Engine and containerd:

```
yum install docker-ce docker-ce-cli containerd.io -y
```

<img src="Screenshots/DockerInstallation-1.JPG">

<img src="Screenshots/DockerInstallation-2.JPG">

* To install a specific version of Docker Engine, list the available versions in the repo, then select and install:

To get the List of available versions:

```
yum list docker-ce --showduplicates | sort -r
```

<img src="Screenshots/AvailableDockerVersions.JPG">

To install any specific version:

For example, `docker-ce-18.09.1`

```
yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io -y
```

Docker is installed but not started. The docker group is created, but no users are added to the group.

<img src="Screenshots/DockerAvailable.JPG">

<img src="Screenshots/IsDockerRunning.JPG">

### Starting the Docker Engine:

```
systemctl start docker
```

### Checking the status & version of Docker Engine:

```
systemctl status docker
```

<img src="Screenshots/StartingDocker.JPG">

```
docker version
```

<img src="Screenshots/DockerVersion.JPG">

### Verify Installation:

Verify that Docker Engine is installed correctly by running the hello-world image.

```
docker run hello-world
```

<img src="Screenshots/DockerHelloWorld.JPG">

#### References:

1. https://docs.docker.com/engine/install/centos/
