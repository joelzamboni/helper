#!/usr/bin/env bash

# Server Ports: 22/tcp, 443/tcp, 943/tcp, 1194/udp

server_name="this is the server name"
country="US"
province="VA"
city="Reston"
org="Company"
email="email@mail.com"

sudo apt-get install -y openvpn easy-rsa
sudo mkdir /etc/openvpn/easy-rsa/
sudo cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/

cat << EOF | sudo -u root tee /etc/openvpn/easy-rsa/vars

export EASY_RSA="`pwd`"
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
export KEY_DIR="$EASY_RSA/keys"
echo NOTE: If you run ./clean-all, I will be doing a rm -rf on $KEY_DIR
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY="US"
export KEY_PROVINCE="CA"
export KEY_CITY="SanFrancisco"
export KEY_ORG="Fort-Funston"
export KEY_EMAIL="me@myhost.mydomain"
export KEY_OU="MyOrganizationalUnit"
export KEY_NAME="EasyRSA"

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

EOF

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
