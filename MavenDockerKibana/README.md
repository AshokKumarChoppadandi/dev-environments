# Creating Kibana Docker Image using `docker-maven-plugin`

## Introduction
This is the Maven project helps in build the docker image for Kibana using the `docker-maven-plugin`. [Click Here](https://github.com/AshokKumarChoppadandi/dev-environments/tree/develop/MavenDockerHelloWorld) To know more about the plugin and building the docker images from it.

## Maven commands to Build & Push Image

***Build:***

The below maven command builds the Docker image and save it to our local machine.

```
mvn docker:build
```

Building an image from the latest version of Kibana. To get the latest version of Elasticsearch. [Click here](https://www.elastic.co/downloads/kibana)

```
mvn docker:build \
-Dkibana.download.url=https://artifacts.elastic.co/downloads/kibana/kibana-7.8.0-linux-x86_64.tar.gz
```

***Push:***

The below maven command pushes the Kibana image to docker registry.

```
mvn docker:push
```

Pushing image to the remote repository, for example: Docker Registry - "docker.io"

```
mvn docker:push -Ddocker.push.registry=docker.io
```

Pushing image by passing the credentials like username and password.

```
mvn docker:push \
-Ddocker.push.registry=docker.io \
-Ddocker.hub.username=REPLACE_WITH_USERNAME \
-Ddocker.hub.password=REPLACE_WITH_PASSWORD
```

***Build & Push:***

The below maven command builds the docker image, save it local and pushes it to docker registry.

```
mvn clean install \
> -Dkibana.download.url=https://artifacts.elastic.co/downloads/kibana/kibana-7.8.0-linux-x86_64.tar.gz \
> -Ddocker.push.registry=docker.io \
> -Ddocker.hub.username=REPLACE_WITH_USERNAME \
> -Ddocker.hub.password=REPLACE_WITH_PASSWORD
```

***Start Container:***

Kibana needs a running Elasticsearch cluster, to start the elasticsearch below is the docker run command:

```
docker run -d \
--name es-docker \
-e ES_CLUSTER_NAME=my-elasticsearch \
-e ES_NODE_NAME=es-docker \
-e ES_MASTER_NODES=es-docker \
-p 9200:9200 ashokkumarchoppadandi/elasticsearch:latest
```

The below maven command start container from the image present in our local. If it doesn't find the image locally, then it pulls the image from the docker repository.

```
mvn docker:start
```

Starting the docker container with environment variables.

```
mvn docker:start \
-Des.hosts=http://es-docker:9200 \
-Dkibana.server.name=es-docker-kibana
```

Docker run command to start the Kibana container.

```
docker run -d \
--name es-docker-kibana \
-e ELASTICSEARCH_HOSTS=http://es-docker:9200 \
-e KIBANA_SERVER_NAME=es-docker-kibana \
--link es-docker:es-docker \
-p 5601:5601 ashokkumarchoppadandi/kibana:latest
```
***Stop Container:***

The below maven command stop the running container and remove it.

```
mvn docker:stop
```

### Using `docker-compose`

#### One Node Cluster

***Start:***

The below `docker-compose` command can be used to start one node Elasticsearch cluster and one node Kibana instance.

```
docker-compose up -d
```

***Status:***

To get the status of all the services which are started using `docker-compose.yml` file

```
docker-compose ps
```

***Logs:***

To get the Logs from all the services which are started using `docker-compose.yml` file

```
docker-compose logs
```

To get the Logs from a specific service which is started using `docker-compose.yml` file

```
docker-compose logs <SERVICE_NAME>
```

***Stop:***

To stop all the services which are started using `docker-compose.yml` file

```
docker-compose down
```

***Environment File:***

The below docker-compose command can be used to start one node Elasticsearch cluster and one node Kibana instance using an environment file.

```
docker-compose -f docker-compose-env.yml --env-file env-file up -d
```

*Status:*

```
docker-compose -f docker-compose-env.yml --env-file env-file ps
```

*Logs:*

```
docker-compose -f docker-compose-env.yml --env-file env-file logs
```

*Stop:*

```
docker-compose -f docker-compose-env.yml --env-file env-file down
```

#### Multi Node Cluster

***Start:***

The below docker-compose command can be used to start multi-node Elasticsearch cluster and one node Kibana instance.

```
docker-compose -f docker-compose-multinode.yml up -d
```

***Status:***

```
docker-compose -f docker-compose-multinode.yml ps
```

***Logs:***

```
docker-compose -f docker-compose-multinode.yml logs
```

```
docker-compose -f docker-compose-multinode.yml logs <SERVICE_NAME>
```

***Stop:***

```
docker-compose -f docker-compose-multinode.yml down
```

## Conclusion

So this project helps in building the Elasticsearch docker image, start and stop containers with configurable properties.

This project also consists of docker.compose.yml, docker-compose-env.yml & docker-compose-multinode.yml files for starting the docker container for single and multinode Elasticsearch clsuter.

### References:

1. Installing docker & docker-compose on CentOS 7 - https://github.com/AshokKumarChoppadandi/dev-environments/tree/develop/DockerSetupOnCentOS7
2. Building Elasticsearch docker image - https://github.com/AshokKumarChoppadandi/dev-environments/tree/develop/MavenDockerElasticsearch
3. Docker documentation - https://docs.docker.com/get-started/
4. Docker Compose documentation - https://docs.docker.com/compose/
5. Docker Maven Plugin - https://dmp.fabric8.io/