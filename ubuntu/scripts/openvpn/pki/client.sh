#!/usr/bin/env bash


echo "Please check the server configuration"
echo "Remote Server: "
read remote_server
echo "Remote Port: "
read remote_port

# Running on LXC notes
# lxc.cgroup.devices.allow = c 10:200 rwm
# mkdir /dev/net
# mknod /dev/net/tun c 10 200
# chmod 666 /dev/net/tun

# Client configuration# Server Ports: 22/tcp, 443/tcp, 943/tcp, 1194/udp
cd /etc/openvpn/easy-rsa/
source vars
./build-key client1

# Copy the following files to the client
#   /etc/openvpn/ca.crt
#   /etc/openvpn/easy-rsa/keys/client1.crt
#   /etc/openvpn/easy-rsa/keys/client1.key

mkdir /root/vpnclient
cp /etc/openvpn/ca.crt /etc/openvpn/easy-rsa/keys/client1.crt /etc/openvpn/easy-rsa/keys/client1.key /root/vpnclient
cd /root


# /etc/openvpn/client.conf
cat << EOF > /root/vpnclient/client.conf
client
proto udp
dev tun
remote ${server_remote} ${port}
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert client1.crt
key client1.key
ns-cert-type server
comp-lzo
verb 3
auth-user-pass
auth-retry interact
EOF

tar czvf vpnclient.tar.gz vpnclient
rm -fr vpnclient