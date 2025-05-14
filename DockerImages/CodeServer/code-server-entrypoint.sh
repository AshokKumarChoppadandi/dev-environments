#!/bin/sh
#set -e

CONFIG="/config.yaml"

sed -i -e "s|HOST|$HOST|g" "${CONFIG}"
sed -i -e "s|PORT|$PORT|g" "${CONFIG}"
sed -i -e "s|LOGIN_PASSWORD|$PASSWORD|g" "${CONFIG}"

cat $CONFIG

code-server --config ${CONFIG}