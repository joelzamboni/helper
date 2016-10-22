#!/usr/bin/env bash

source server_config.sh
[ $(id -u) != 0 ] && echo 'please execute as super user' && exit 1
export PATH=/sbin:/usr/sbin:/bin:/usr/bin:${PATH}
export DEBIAN_FRONTEND=noninteractive

cat << EOF > /etc/hosts
127.0.0.1 localhost
${ip} ${hostname}.${domainname} ${hostname}

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

cat << EOF > /etc/network/interfaces
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

echo ${hostname}.${domainname} > /etc/hostname
hostname ${hostname}.${domainname}

apt-get update
apt-get dist-upgrade -y
apt-get install -y ntp acl samba krb5-user smbclient cups winbind


rm /etc/samba/smb.conf

systemctl unmask samba-ad-dc.service

echo TODO: samba-tool command

# samba-tool domain provision --realm ${domainname^^} --domain ${netbiosdomain^^} --server-role=dc --use-rfc2307 --option="dns forwarder = ${dns_forwarder}"  --option="interfaces=lo eth0" --option="bind interfaces only=yes" --adminpass ${administrator_password}

# samba-tool domain join ${domainname^^} DC -Uadministrator --realm ${domainname^^} --option="dns forwarder = ${dns_forwarder}" --option="interfaces=lo eth0" --option="bind interfaces only=yes" 

