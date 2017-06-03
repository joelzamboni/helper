
# Server
port 1195
proto udp
dev tun
ifconfig 192.168.12.5 192.168.12.6
route 10.12.0.0 255.255.224.0
route 10.12.192.0 255.255.240.0
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
secret static.key

openvpn --genkey --secret static.key


# Client
proto udp
dev tun
remote 52.1.105.226 1195
ifconfig 192.168.12.6 192.168.12.5
route 10.12.142.0 255.255.254.0
keepalive 10 120
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3
secret static.key
