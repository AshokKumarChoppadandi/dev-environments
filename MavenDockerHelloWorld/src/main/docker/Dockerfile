FROM openjdk:8

MAINTAINER AshokKumarChoppadandi ashokkumar98778@gmail.com

WORKDIR /

ENV INPUT_ARG World

COPY maven/MavenDockerHelloWorld-1.0-SNAPSHOT.jar /

CMD java -cp /MavenDockerHelloWorld-1.0-SNAPSHOT.jar com.bigdata.docker.HelloWorld $INPUT_ARG