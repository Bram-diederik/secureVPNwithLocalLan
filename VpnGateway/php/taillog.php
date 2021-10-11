<?php 
session_start();
if(empty($_SESSION["userId"])) {
die();
}
echo shell_exec('tail -n 30 /var/log/openvpn/ovpn.log');
 ?>
