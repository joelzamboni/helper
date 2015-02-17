#!/usr/bin/env bash

source config.sh


sudo apt-get update
sudo apt-get dist-upgrade


cat << EOF | sudo -u root tee /etc/hosts
127.0.0.1 localhost
127.0.0.1 ${hostname}.${domainname} ${hostname}
${ip} ${hostname}.${domainname} ${hostname}

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

cat << EOF | sudo -u root tee /etc/network/interfaces
# /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address ${ip}
netmask ${netmask}
gateway ${gw}
dns-nameserver ${ip}
EOF




