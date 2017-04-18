#!/usr/bin/env bash

# TODO: Add TLS
# https://community.openvpn.net/openvpn/wiki/GettingStartedwithOVPN
# https://community.openvpn.net/openvpn/wiki/Hardening


# Server Ports: 1194/udp

server_name="this is the server name"
server_remote="remote IP"
country="US"
province="VA"
city="Reston"
org="Company"
email="email@mail.com"
easy_rsa_dir="/etc/openvpn/easy-rsa"
ou="Tech"
port=""
client=""

# Running on LXC notes
# lxc.cgroup.devices.allow = c 10:200 rwm
# mkdir /dev/net
# mknod /dev/net/tun c 10 200
# chmod 666 /dev/net/tun


[ $(id -u) != 0 ] && echo 'please use root' && exit 1


apt-get install -y openvpn easy-rsa zip
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
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
EOF

update-rc.d openvpn enable

# Client configuration
cd /etc/openvpn/easy-rsa/
source vars
./build-key ${client}

mkdir -p /root/vpnclient
cd /root/vpnclient


# /etc/openvpn/client.conf
cat << EOF > /root/vpnclient/${client}.ovpn
client
proto udp
dev tun
remote ${server_remote} ${port}
resolv-retry infinite
nobind
persist-key
persist-tun
ns-cert-type server
comp-lzo
verb 3
auth-user-pass
auth-retry interact

EOF
echo "<ca>" >> ${client}.ovpn
cat /etc/openvpn/ca.crt >> ${client}.ovpn
echo "</ca>" >> ${client}.ovpn
echo "<cert>" >> ${client}.ovpn
cat /etc/openvpn/easy-rsa/keys/${client}.crt >> ${client}.ovpn
echo "</cert>" >> ${client}.ovpn
echo "<key>" >> ${client}.ovpn
cat /etc/openvpn/easy-rsa/keys/${client}.key >> ${client}.ovpn
echo "</key>" >> ${client}.ovpn
