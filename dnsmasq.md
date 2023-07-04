If you want some local systems to always connect to the vpn.
use this dnsmasq setting.

please change the mac addesss the ip address the hostname and the vpn_gateway IP. 

```
dhcp-host=XX:XX:XX:XX:XX:XX,set:localvpn,192.168.X.X,myhostname
dhcp-option=tag:cpxhosts,option:dns-server,8.8.8.8,8.8.4.4
dhcp-option=tag:cpxhosts,option:router,vpn_gateway
```
