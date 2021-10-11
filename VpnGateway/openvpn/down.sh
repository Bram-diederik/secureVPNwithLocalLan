#!/bin/sh
iptables -t nat -D POSTROUTING ! -o lo -j MASQUERADE
sysctl -w net.ipv4.ip_forward=0
exit 0
