#!/usr/bin/env bash

echo "Create self signed certificates"
echo "What is the domain for the test certificates? "
read DOMAIN

# Private Key
openssl genrsa -des3 -out ${DOMAIN}.key 1024

# Generate CSR
openssl req -nodes -newkey rsa:2048 -keyout ${DOMAIN}.key -out ${DOMAIN}.csr

# Remove passprase from key
cp ${DOMAIN}.key ${DOMAIN}.key.org
openssl rsa -in ${DOMAIN}.key.org -out ${DOMAIN}.key

# Generate certificate
openssl x509 -req -days 365 -in ${DOMAIN}.csr -signkey ${DOMAIN}.key -out ${DOMAIN}.crt

# Display information for Amazon
echo Private
openssl rsa -in ${DOMAIN} -text
echo Public
openssl x509 -inform PEM -in ${DOMAIN}.crt
