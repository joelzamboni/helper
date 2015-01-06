#!/usr/bin/env bash


sudo add-apt-repository ppa:saltstack/salt -y
sudo apt-get update

# Master
sudo apt-get install salt-master python-software-properties salt-minion salt-syndic -y

# Minion
sudo apt-get install python-software-properties salt-minion -y 
