#!/bin/sh
#set -e

CONFIG_FILE_PATH="${LOGSTASH_CONFIG_DIR}/${LOGSTASH_CONFIG_FILE}"

is_config_file_exists() {
  if [ ! -f "$CONFIG_FILE_PATH" ]; then
    echo "There is no config file - $CONFIG_FILE_PATH"
    echo "Check the logstash config file!"
    exit 1
  else
    echo "Logstash config file exists at ${CONFIG_FILE_PATH}"
  fi
}

test_config_file () {
  if ! "$LOGSTASH_HOME"/bin/logstash -f "$CONFIG_FILE_PATH" --config.test_and_exit; then
    echo "The Logstash config file is not correct. Please check the config file - ${CONFIG_FILE_PATH}"
    cat "${CONFIG_FILE_PATH}"
    exit 1
  else
    echo "Test succeeded."
  fi
}

echo "Starting Logstash on host - ${LOGSTASH_HOSTNAME}, using the Config file is - ${CONFIG_FILE_PATH}"
echo "Checking Logstash config file"
is_config_file_exists
echo "Testing the Logstash config file"
test_config_file
echo "Starting Logstash process..."

"$LOGSTASH_HOME"/bin/logstash -f "$CONFIG_FILE_PATH"