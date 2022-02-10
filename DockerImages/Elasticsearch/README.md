# Creating Elasticsearch Docker Image using `docker-maven-plugin`

## Introduction

This is the Maven project helps in build the docker image for Elasticsearch using the `docker-maven-plugin`. [Click Here](https://github.com/AshokKumarChoppadandi/dev-environments/tree/develop/MavenDockerHelloWorld) To know more about the plugin and building the docker images from it.

## Maven commands to Build & Push Image

***Build:***

The below maven command build the image and save it to our local machine.

```
mvn docker:build
```

Building an image from the latest version of Elasticsearch. To get the latest version of Elasticsearch. [Click here](https://www.elastic.co/downloads/elasticsearch)

```
mvn docker:build -Des.download.url=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz
```

***Push:***

The below maven command pushes the image to docker registry.

```
mvn docker:push
```

Pushing image to the remote repository, for example: Docker Registry - "docker.io"

```
mvn docker:push -Ddocker.push.registry=docker.io
```

Pushing image by passing the credentials like username and password.

```
mvn docker:push -Ddocker.push.registry=docker.io -Ddocker.hub.username=REPLACE_WITH_USERNAME -Ddocker.hub.password=REPLACE_WITH_PASSWORD
```

***Build & Push:***

The below maven command builds the docker image, save it local and pushes it to docker registry.

```
mvn clean install \
> -Des.download.url=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz \
> -Ddocker.push.registry=docker.io \
> -Ddocker.hub.username=REPLACE_WITH_USERNAME \
> -Ddocker.hub.password=REPLACE_WITH_PASSWORD
```

***Start Container:***

The below maven command start container from the image present in our local. If it doesn't find the image locally, then it pulls the image from the docker repository.

```
mvn docker:start
```

Starting the docker container with environment variables.

```
mvn docker:start -Des.cluster.name=my-elasticsearch-cluster -Des.node.name=eshost1
```

***Stop Container:***

The below maven command stop the running container and remove it.

```
mvn docker:stop
```

## Conclusion

So this project helps in building the Elasticsearch docker image, start and stop containers with configurable properties.

This project also consists of `docker.compose.yml`, `docker-compose-env.yml` & `docker-compose-multinode.yml` files for starting the docker container for single and multinode Elasticsearch clsuter.
