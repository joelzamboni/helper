


```
iptables -t nat -A PREROUTING -p <protocol> -d <ip>/<mask> --dport <port> -j DNAT --to <ip>:<port>
```
