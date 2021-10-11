# Secure VPN With Local Lan
This git is for users who want a VPN Connection to their home network. With a secure VPN Connection to the internet. 

two Machines are uses to create this setup. VpnGateway and incomingVpnServer.

# Setup VpnGateway
for this you require an VPN hosting using openvpn
place working openvpn configurations in /etc/openvpn/clientConfig 
copy up.sh and down.sh to /etc/openvpn/
apply
```
script-security 3 
route-up /etc/openvpn/up.sh
down /etc/openvpn/down.sh
```
to every openvpn configuration in clientConfig. 

install the vpnadmin.sh to /usr/bin/local and grant it passwordless sudo for the www-data user

copy /etc/rsyslog.d/openvpn.conf

copy the php site.



# Setup incomingVpnServer
install a openvpn server. I recommend use a script like https://www.pivpn.io/

copy the up.sh script to /etc/openvpn/
apply
```
script-security 3 
up /etc/openvpn/up.sh
```
to the server.conf



