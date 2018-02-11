#!/usr/bin/env bash

source config.sh

cd ${pki_dir}
source vars
./build-key $1

# Copy the following files to the client
#   /etc/openvpn/ca.crt
#   /etc/openvpn/easy-rsa/keys/client1.crt
#   /etc/openvpn/easy-rsa/keys/client1.key

mkdir /root/vpnclient
cp /etc/openvpn/ca.crt ${pki_dir}/keys/$1.crt ${pki_dir}/keys/$1.key /root/vpnclient
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
