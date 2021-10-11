<?php 
session_start();
if(empty($_SESSION["userId"])) {
die();
}


exec('sudo /usr/local/bin/vpnadmin.sh status', $output, $retval);  

preg_match("/ActiveState=(.*)/",$output[0],$match);
$activestate=$match[1];
preg_match("/net.ipv4.ip_forward = (\d{1})/",$output[1],$match);
$ipforward = $match[1];

if (empty($_SESSION["activestate"])) 
{
$_SESSION["activestate"] =$activestate;
$_SESSION["ipforward"]= $ipforward;
} else {
if (($_SESSION["activestate"] !=$activestate) || ($_SESSION["ipforward"]!= $ipforward)) {
   echo "change";
}
 
}
 ?>
