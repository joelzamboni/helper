#!/usr/bin/env bash


# Master
sudo add-apt-repository ppa:saltstack/salt
sudo apt-get update
sudo apt-get install salt-master python-software-properties salt-minion salt-syndic

# Minion
sudo add-apt-repository ppa:saltstack/salt
sudo apt-get update
sudo apt-get install python-software-properties salt-minion


