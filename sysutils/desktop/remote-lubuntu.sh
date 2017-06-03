#!/usr/bin/env bash

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y lubuntu-desktop tightvncserver
sudo apt-get autoclean
sudo rm /var/cache/apt/archives/*.deb

cat << EOF | sudo -u root tee /etc/lightdm/lightdm.conf.d/30-vnc.conf
[VNCServer]
enabled=true
port=5900
width=1280
height=1024
depth=24
EOF


