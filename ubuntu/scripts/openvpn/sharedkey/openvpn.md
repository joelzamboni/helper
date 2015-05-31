

# VPN with pre shared key using OpenVPN

# Introduction

OpenVPN can help you to secure connect different network or devices by creating encripted

### Site A configuration (server):

```
port 1195
proto udp
dev tun
ifconfig 192.168.12.5 192.168.12.6
route <site-b-ip> <site-b-mask>
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
secret static.key
```

Create the shared secret key:

```
openvpn --genkey --secret static.key
```

### Site B configuration (client):

```
proto udp
dev tun
remote X.X.X.X 1195
ifconfig 192.168.12.6 192.168.12.5
route <site-a-ip> <site-a-mask>
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3
secret static.key
```
