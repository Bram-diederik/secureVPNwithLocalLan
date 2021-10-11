# Secure VPN With Local Lan
This git is for users who want a VPN Connection to their home network. With a secure VPN Connection to the internet. 

two Machines are uses to create this setup. VpnGateway and incomingVpnServer.

# Setup VpnGateway
for this you require an VPN hosting using openvpn
1) place working openvpn configurations in /etc/openvpn/clientConfig 
2)copy up.sh and down.sh to /etc/openvpn/
3) apply
```
script-security 3 
route-up /etc/openvpn/up.sh
down /etc/openvpn/down.sh
```
to every openvpn configuration in clientConfig. 

4) install the vpnadmin.sh to /usr/bin/local and grant it passwordless sudo for the www-data user

5) copy /etc/rsyslog.d/openvpn.conf

6) copy the php site.



# Setup incomingVpnServer
1) install a openvpn server. I recommend use a script like https://www.pivpn.io/

2) copy the up.sh script to /etc/openvpn/
3) apply
```
script-security 3 
up /etc/openvpn/up.sh
```
to the server.conf



