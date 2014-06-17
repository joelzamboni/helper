#!/usr/bin/env bash

# Configure serial access on Ubuntu 
# https://help.ubuntu.com/community/SerialConsoleHowto

cat << EOF | sudo -u root tee /etc/init/ttyS0.conf
# ttyS0 - getty
#
# This service maintains a getty on ttyS0 from the point the system is
# started until it is shut down again.

start on stopped rc or RUNLEVEL=[2345]
stop on runlevel [!2345]

respawn
exec /sbin/getty -L 9600 ttyS0 vt102
EOF

sudo start ttyS0

