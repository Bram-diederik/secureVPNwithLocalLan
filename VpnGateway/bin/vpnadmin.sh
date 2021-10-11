#!/bin/sh

if [ "$1" = "ls" ]; 
then 
   status=`systemctl show openvpn@client --no-page)` 

   status_text=`echo "$status" | grep 'ActiveState='`
   if [ "$status_text" = "ActiveState=active" ];
      then
        link=`readlink /etc/openvpn/client.conf`
      else
       link="null"
      fi

	for f in /etc/openvpn/clientConfig/*;
   	 do 
          conf=`echo $f | grep -E "\w+\.conf" -o`;
          if [ "$link" = "$f" ];
	   then
             echo "* $conf";
           else
             echo "$conf";
          fi
	done
fi
if [ "$1" = "status" ]; 
then 
   status=`systemctl show openvpn@client --no-page)` 

#echo $status
   status_text=`echo "$status" | grep 'ActiveState='` 
   echo $status_text
   sysctl net.ipv4.ip_forward
fi
if [ "$1" = "start" ]; 
  then
    if [ -z "$2" ];
    then
      service openvpn start
    else
      link=`readlink /etc/openvpn/client.conf`
      for f in /etc/openvpn/clientConfig/*;
         do 
           conf=`echo $f | grep -E "\w+\.conf" -o`; 
           if [ "$conf" = $2 ];
           then
             ln -sf $f /etc/openvpn/client.conf
             service openvpn restart
           fi
          done
     fi
fi
if [ "$1" = "stop" ]; 
  then
    if [ -z "$2" ];
    then 
       service openvpn stop
       sysctl -w net.ipv4.ip_forward=0
    else
      if [ "route-local" = $2 ];
           then
             service openvpn stop
             sysctl -w net.ipv4.ip_forward=1 
           fi
     fi
fi
