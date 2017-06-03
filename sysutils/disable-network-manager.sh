#!/usr/bin/env bash

sudo stop network-manager
echo "manual" | sudo tee /etc/init/network-manager.override


