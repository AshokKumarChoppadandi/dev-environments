#!/bin/sh
#set -e

#echo $export JAVA_HOME=/usr/lib/jvm/$(ls /usr/lib/jvm/ | grep java-1.8.0-openjdk-1.8.0)
echo "export JAVA_HOME=/usr/lib/jvm/$(ls /usr/lib/jvm/ | grep java-1.8.0-openjdk-1.8.0)" >> ~/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc

source ~/.bashrc
elasticsearch



