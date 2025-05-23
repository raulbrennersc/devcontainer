#!/bin/bash

if [ ! -f already_ran ]; then
  if [[ $CUSTOM_SSH_PORT ]]; then
    sudo sudo sed -i 's/Port .*/Port '$CUSTOM_SSH_PORT'/' /etc/ssh/sshd_config
  fi

  if [[ $KEY_TO_AUTHORIZE ]]; then
    mkdir -p .ssh
    echo $KEY_TO_AUTHORIZE >>.ssh/authorized_keys
    sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
  fi

  if [[ $DEVCONTAINER_NAME ]]; then
    echo "export DEVCONTAINER_NAME=$DEVCONTAINER_NAME" >>.zprofile
  fi

  touch already_ran

fi
sudo chown -R ${USER}:${USER} /var/run/docker.sock
sudo chown :kvm /dev/kvm
sudo /etc/init.d/ssh start
# sudo /etc/init.d/docker start

sleep infinity
