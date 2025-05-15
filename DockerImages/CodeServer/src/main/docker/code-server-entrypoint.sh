#!/bin/sh
#set -e

CONFIG="/config.yaml"

sed -i -e "s|HOST|$HOST|g" "${CONFIG}"
sed -i -e "s|PORT|$PORT|g" "${CONFIG}"
sed -i -e "s|DEFAULT_LOGIN_PASSWORD|$DEFAULT_LOGIN_PASSWORD|g" "${CONFIG}"

cat $CONFIG

code-server --config ${CONFIG}