#!/usr/bin/env bash

# TODO: create full file with all parameters

# Server Ports: 22/tcp, 443/tcp, 943/tcp, 1194/udp

server_name="this is the server name"

sudo apt-get install openvpn easy-rsa
sudo mkdir /etc/openvpn/easy-rsa/
sudo cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/

# Check this parameters in the file /etc/openvpn/easy-rsa/vars
export KEY_COUNTRY="US"
export KEY_PROVINCE="NC"
export KEY_CITY="Winston-Salem"
export KEY_ORG="Example Company"
export KEY_EMAIL="steve@example.com"
export KEY_CN=VPN
export KEY_NAME=VPN
export KEY_OU=VPN
export KEY_ALTNAMES=VPN

sudo su -

cd /etc/openvpn/easy-rsa/
source vars
./clean-all
./build-ca
./build-key-server ${server_name}

./build-dh

cd keys/
cp ${server_name}.crt ${server_name}.key ca.crt dh2048.pem /etc/openvpn/

# Server Configuration
# TODO: create the file server.conf inside the script
# /etc/openvpn/server.conf

port 1194
proto udp
dev tun
ca ca.crt
cert ${server_name}.crt
key ${server_name}.key
dh dh2048.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
# additional routes
# push "route 10.0.4.0 255.255.255.0"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
client-cert-not-required
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
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
tar czvf vpnclient.tar.gz vpnclient
rm -fr vpnclient


# /etc/openvpn/client.conf
client
proto udp
dev tun
remote my-server-1 1194
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
