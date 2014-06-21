#!/usr/bin/env bash

sudo apt-get install openvpn easy-rsa
mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/


export KEY_COUNTRY="US"
export KEY_PROVINCE="NC"
export KEY_CITY="Winston-Salem"
export KEY_ORG="Example Company"
export KEY_EMAIL="steve@example.com"
export KEY_CN=MyVPN
export KEY_NAME=MyVPN
export KEY_OU=MyVPN


cd /etc/openvpn/easy-rsa/
source vars
./clean-all
./build-ca

./build-key-server myservername

./build-dh

cd keys/
cp myservername.crt myservername.key ca.crt dh1024.pem /etc/openvpn/

cd /etc/openvpn/easy-rsa/
source vars
./build-key client1

# Copy the following files to the client
#   /etc/openvpn/ca.crt
#   /etc/openvpn/easy-rsa/keys/client1.crt
#   /etc/openvpn/easy-rsa/keys/client1.ke


