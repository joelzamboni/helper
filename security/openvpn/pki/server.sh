#!/usr/bin/env bash

server_name="openvpn"
server_remote="server.apps.com"
country="US"
province="VA"
city="Reston"
org="Company"
email="info@webera.com"
pki_dir="/etc/openvpn/webera"
ou="Tech"
port="1194"

# Running on LXC notes
# lxc.cgroup.devices.allow = c 10:200 rwm
# mkdir /dev/net
# mknod /dev/net/tun c 10 200
# chmod 666 /dev/net/tun


[ $(id -u) != 0 ] && echo 'please use root' && exit 1


apt-get install -y openvpn easy-rsa zip
mkdir ${pki_dir}
cp -r /usr/share/easy-rsa/* ${pki_dir}

cat << EOF > ${pki_dir}/vars
export EASY_RSA=${pki_dir}
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=\`${pki_dir}/whichopensslcnf ${pki_dir}\`
export KEY_DIR=${pki_dir}/keys
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
EOF


cd ${pki_dir}
ln -s openssl-1.0.0.cnf openssl.cnf
source vars
./clean-all
./build-ca --batch
./build-key-server --batch ${server_name}

./build-dh

cd keys/
cp ${server_name}.crt ${server_name}.key ca.crt dh2048.pem /etc/openvpn/

openvpn --genkey --secret /etc/openvpn/ta.key


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
tls-auth ta.key
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

