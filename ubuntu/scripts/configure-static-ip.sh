#!/usr/bin/env bash

# Just to configure static IP on ubuntu
# TODO: disable network manager


echo -n 'IP Address: '
read ip
echo -n 'Netmask: '
read netmask
echo -n 'Gateway: '
read gw

cat << EOF | sudo -u root  tee /etc/network/interfaces
# /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address ${ip}
netmask ${netmask}
gateway ${gw}
dns-nameserver 8.8.8.8 8.8.4.4
EOF




