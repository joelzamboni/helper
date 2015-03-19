#!/usr/bin/env bash

# Server Ports: 22/tcp, 443/tcp, 943/tcp, 1194/udp

server_name="this is the server name"
server_remote="remote IP"
country="US"
province="VA"
city="Reston"
org="Company"
email="email@mail.com"
easy_rsa_dir="/etc/openvpn/easy-rsa"
ou="Tech"
port="11111"

# Running on LXC notes
# lxc.cgroup.devices.allow = c 10:200 rwm
# mkdir /dev/net 
# mknod /dev/net/tun c 10 200 
# chmod 666 /dev/net/tun


[ $(id -u) != 0 ] && echo 'please use root' && exit 1


apt-get install -y openvpn easy-rsa
mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/

cat << EOF > /etc/openvpn/easy-rsa/vars
export EASY_RSA=${easy_rsa_dir}
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=$(${easy_rsa_dir}/whichopensslcnf ${easy_rsa_dir})
export KEY_DIR=${easy_rsa_dir}/keys
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY=${country}
export KEY_PROVINCE=${province}
export KEY_CITY=${city}
export KEY_ORG=${org}
export KEY_EMAIL=${email}
export KEY_OU=${ou}
export KEY_NAME="OpenVPN"
export KEY_CN=VPN
export KEY_NAME=VPN
export KEY_ALTNAMES=VPN
EOF


cd /etc/openvpn/easy-rsa/
ln -s openssl-1.0.0.cnf openssl.cnf
source vars
./clean-all
./build-ca
./build-key-server ${server_name}

./build-dh

cd keys/
cp ${server_name}.crt ${server_name}.key ca.crt dh2048.pem /etc/openvpn/

# Server Configuration
# /etc/openvpn/server.conf

cat << EOF > /etc/openvpn/server.conf
port ${port}
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
# client-cert-not-required
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login

EOF

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
