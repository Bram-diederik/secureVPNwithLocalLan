#!/bin/sh
IF=eth0
TUN=tun0
VPN_GATEWAY=192.168.112.4

## Enable Forwarding for the TUN interface
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i $TUN -j ACCEPT 
iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE 

## Create seperate IP routing table for the TUN Interface
ip rule add from 10.8.0.0/24 table 11
ip rule add to 10.8.0.0/24 table 11
ip route add 10.8.0.0/24 dev $TUN table 11
## Make the VPN Gateway the default gateway
ip route add default via $VPN_GATEWAY dev $IF table 11
## Uncomment and edit your local network ranges 
## or else you have no local network and the whole setup is pointless
#ip route add <localIPRange>  dev <interface> table 11
exit 0
