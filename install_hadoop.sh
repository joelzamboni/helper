#!/usr/bin/env bash

set -x

HDU='hduser'
HDHOME='/opt/hadoop'

# Temporary clean
sudo userdel -r $HDU
sudo groupdel hadoop


install_packages() {
  sudo apt-get install -y openjdk-7-jdk openssh-server
  sudo ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/lib/jvm/jdk
}


create_user() {
  sudo groupadd hadoop
  sudo useradd -d ${HDHOME} -g hadoop -G sudo -m -s /bin/bash ${HDU}
}


ssh_keys() {
  sudo -u ${HDU} ssh-keygen -t rsa -P '' -f ${HDHOME}/.ssh/id_rsa
  sudo -u ${HDU} cp ${HDHOME}/.ssh/id_rsa.pub ${HDHOME}/.ssh/authorized_keys
  sudo -u ${HDU} ssh -o "StrictHostKeyChecking no" localhost
}

install_packages
create_user
ssh_keys



