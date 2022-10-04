# FROM centos:7
#
# LABEL maintainer="Ashok Kumar Choppadandi <ashokkumar98778@gmail.com>"
#
# USER root
#
# WORKDIR /
#
# ARG HAPROXY_VERSION=2.6.5
#
# # ARG HAPROXY_CONFIG_DIR=/etc/haproxy/haproxy-bkp2.cfg
#
# RUN yum update -y && yum install haproxy -y && mkdir /var/lib/haproxy/dev
#
# COPY config/haproxy-bkp2.cfg /usr/local/haproxy-bkp2.cfg
# COPY config/99-haproxy.conf /etc/rsyslog.d/99-haproxy.conf
#
# CMD haproxy -c -f /usr/local/haproxy-bkp2.cfg && tail -f /var/log/haproxy.log

FROM haproxy:2.6.5
COPY config/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
