#!/bin/sh
#set -e

echo "Application Config File - ${APPLICATION_CONFIG_FILE}"
echo "Consumer Properties File - ${CONSUMER_PROPERTIES_FILE}"

sed -i -e "s/SECURITY_PROTOCOL/$SECURITY_PROTOCOL/g" "${CONSUMER_PROPERTIES_FILE}"
sed -i -e "s/KEY_DESERIALIZER/$KEY_DESERIALIZER/g" "${CONSUMER_PROPERTIES_FILE}"
sed -i -e "s/VALUE_DESERIALIZER/$VALUE_DESERIALIZER/g" "${CONSUMER_PROPERTIES_FILE}"

sleep 15
echo "Starting Cluster Manager for Apache Apache (CMAK) on port - ${HTTP_PORT}"

"$CMAK_HOME_DIR"/bin/cmak nfig.file="${APPLICATION_CONFIG_FILE}" -Dhttp.port="${HTTP_PORT}"