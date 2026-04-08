#!/bin/bash

if [ ! -f already_ran ]; then
  if [[ $CUSTOM_SSH_PORT ]]; then
    sudo sed -i "s/Port .*/Port $CUSTOM_SSH_PORT/" /etc/ssh/sshd_config
  fi

  if [[ $KEY_TO_AUTHORIZE ]]; then
    mkdir -p ~/.ssh
    echo "$KEY_TO_AUTHORIZE" >>~/.ssh/authorized_keys
    chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
  fi

  if [[ $DEVCONTAINER_NAME ]]; then
    echo "export DEVCONTAINER_NAME=$DEVCONTAINER_NAME" >>~/.bashrc
  fi

  touch already_ran
fi

sudo chown ${USER}:${USER} /var/run/docker.sock 2>/dev/null || true

sudo /etc/init.d/ssh start

sleep infinity
