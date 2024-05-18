#!/bin/sh
#set -e

JUPYTER_CONFIG_FILE=$JUPYTER_CONFIG_DIR/jupyter_notebook_config.py

SERVICE_TYPE=$1
echo "Input Service Type - ${SERVICE_TYPE}"
echo "Configuring the Jupyter Properties..."

case "${SERVICE_TYPE,,}" in
  "sh" )
    echo "Starting shell"
    tail -f /dev/null
  ;;

  "notebook" )
    echo "Starting Jupyter Notebook Service..."
    command="jupyter notebook --no-browser --ip=0.0.0.0 --port=$JUPYTER_NOTEBOOK_PORT"

    if [ ! -z ${JUPYTER_TOKEN} ]; then
      command+=" --IdentityProvider.token='${JUPYTER_TOKEN}'"
    fi

    if [ ! -z ${JUPYTER_PASSWORD} ]; then
      command+=" --PasswordIdentityProvider.hashed_password='${JUPYTER_PASSWORD}'"
    fi

    if [ ! -z ${JUPYTER_ALLOW_PASSWORD_RESET} ]; then
      command+=" --PasswordIdentityProvider.allow_password_change=${JUPYTER_ALLOW_PASSWORD_RESET}"
    fi

    echo "$command"
    eval "$command"
  ;;
esac
