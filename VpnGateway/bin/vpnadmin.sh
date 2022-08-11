#!/bin/bash

ipenable() {
   if grep -q 0 /proc/sys/net/ipv4/ip_forward;
     then
        sysctl -w net.ipv4.ip_forward=1;
        iptables -t nat -A POSTROUTING ! -o lo -j MASQUERADE;
   fi
}


ipdisable() {
   if grep -q 1 /proc/sys/net/ipv4/ip_forward;
     then
        sysctl -w net.ipv4.ip_forward=0;
        iptables -t nat -D POSTROUTING ! -o lo -j MASQUERADE;
   fi
}
if [ "$1" = "help" ]; 
then
  echo "general help of a custom script to switch between vpn gateways"
  echo "ls : list connections and show current used"
  echo "status : shows the status"
  echo "start : [connection] starts a connection"
  echo "stop : [route-local] stops or stops and start local routing"
  echo "NULL : integration with https://github.com/tobias-kuendig/hacompanion#custom-scripts that does not accept a argument"
fi

if [ "$1" = "ls" ]; 
then 
   status=`systemctl show openvpn@client --no-page` 

   status_text=`echo "$status" | grep 'ActiveState='`
   if [ "$status_text" = "ActiveState=active" ];
      then
        link=`readlink /etc/openvpn/client.conf`
      else
       link="null"
      fi

	for f in /etc/openvpn/clientConfig/*;
   	 do 
          conf=`echo $f | grep -E "[A-Za-z0-9_\-]+\.conf" -o`;
          if [ "$link" = "$f" ];
	   then
             echo "* $conf";
           else
             echo "$conf";
          fi
	done
fi
if [ "$1" = "status" ]
then 
   status=`systemctl show openvpn@client --no-page` 

#echo $status
   status_text=`echo "$status" | grep 'ActiveState='` 
   echo $status_text
   sysctl net.ipv4.ip_forward
   if [ "$status_text" = "ActiveState=active" ];
      then
        link=`readlink /etc/openvpn/client.conf`
      else
       link="null"
      fi

   for f in /etc/openvpn/clientConfig/*;
   do 
     conf=`echo $f | grep -E "[A-Za-z0-9_\-]+\.conf" -o`;
     if [ "$link" = "$f" ];
       then
          conf2=${conf::-5}
           #conf=`echo $conf | cut -c 5`;
           echo "$conf2";
       break
     fi
   done


fi
if [ "$1" = "start" ]; 
  then
    if [ -z "$2" ];
    then
        date +"%b %d %T `hostname` vpnadmin: openvpn start $2" >> /var/log/openvpn/ovpn.log
	service openvpn start
        ipenable
    else
      link=`readlink /etc/openvpn/client.conf`
      for f in /etc/openvpn/clientConfig/*;
         do 
           conf=`echo $f | grep -E "[A-Za-z0-9_\-]+\.conf" -o`; 
           if [ "$conf" = $2 ];
           then
             ln -sf $f /etc/openvpn/client.conf
             service openvpn restart
             ipenable
           fi
          done
     fi
fi
if [ "$1" = "stop" ]; 
  then
    if [ -z "$2" ];
    then 
       date +"%b %d %T `hostname` vpnadmin: Forwaring stopped" >> /var/log/openvpn/ovpn.log
       service openvpn stop
       ipdisable
    else
      if [ "route-local" = $2 ];
           then
             date +"%b %d %T `hostname` vpnadmin: Local routing started" >> /var/log/openvpn/ovpn.log
	     service openvpn stop
             ipenable
           fi
     fi
fi

if [ ! "$1" ]
then 
   status=`systemctl show openvpn@client --no-page` 

   status_text=`echo "$status" | grep 'ActiveState='` 
#   echo $status_text
#   sysctl net.ipv4.ip_forward
   if [ "$status_text" = "ActiveState=active" ];
      then
        link=`readlink /etc/openvpn/client.conf`
        for f in /etc/openvpn/clientConfig/*;
        do 
          conf=`echo $f | grep -E "[A-Za-z0-9_\-]+\.conf" -o`;
          if [ "$link" = "$f" ];
            then
            conf2=${conf::-5}
            #conf=`echo $conf | cut -c 5`;
            echo "$conf2";
            echo "icon:mdi:lan-connect"
	    ip=`curl icanhazip.com 2> /dev/null`
            echo "ip_address:$ip"
            break
          fi
        done
   else 
      echo down
      echo "icon:mdi:lan-disconnect"
      echo ip_address:null
   fi
fi
