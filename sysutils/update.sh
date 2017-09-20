#!/usr/bin/env bash

set -x

sudo apt update -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo -H pip install --upgrade pip awscli ansible termius softlayer
sudo curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
sudo chmod +x /usr/local/bin/ecs-cli
gcloud components update
