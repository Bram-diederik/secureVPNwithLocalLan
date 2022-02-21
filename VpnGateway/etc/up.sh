#!/bin/sh
if grep -q 0 /proc/sys/net/ipv4/ip_forward;
     then
        sysctl -w net.ipv4.ip_forward=1;
        iptables -t nat -A POSTROUTING ! -o lo -j MASQUERADE;
fi
