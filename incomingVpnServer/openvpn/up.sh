#!/bin/sh
iptables -A FORWARD -i tun0 -j ACCEPT 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
ip route add 10.8.0.0/24 dev tun0 table 11
ip route add default via 192.168.112.4 dev eth0 table 11
ip rule add from 10.8.0.0/24 table 11
ip rule add to 10.8.0.0/24 table 11
exit 0
