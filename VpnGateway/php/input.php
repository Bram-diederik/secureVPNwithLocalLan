<?php
session_start();

if (empty($_SESSION["userId"])) {
die();
}

echo foo;

exec('sudo /usr/local/bin/vpnadmin.sh status', $output, $retval);  

preg_match("/ActiveState=(.*)/",$output[0],$match);
$activestate=$match[1];
preg_match("/net.ipv4.ip_forward = (\d{1})/",$output[1],$match);
$ipforward = $match[1];

$output=null;
$retval=null;
exec('sudo /usr/local/bin/vpnadmin.sh ls', $output, $retval);  
echo "<form name=\"vpn\" method=\"post\">";
foreach($output as $conf) {

  # * in front means its set.
  # 
  
  if (substr($conf,0,1) == "*") {
  $conf = substr($conf,2);
  $name =  substr($conf,0,strlen($conf) -5);
  echo "<input type=\"radio\" id=\"conf\" name=\"conf\" value=\"$conf\" checked=\"true\">$name<br>\n";
} else {
  $name =  substr($conf,0,strlen($conf) -5);
  echo "<input type=\"radio\" id=\"conf\" name=\"conf\" value=\"$conf\">$name<br>\n";
}
}
if (($activestate=="inactive") && ($ipforward== "0"))  {
echo ' <input type="radio" id="conf" name="conf" value="stop" checked="true">stop<br>';
} else {
echo ' <input type="radio" id="conf" name="conf" value="stop">stop<br>';
}
if (($activestate=="inactive") && ($ipforward== "1"))  {
echo '<input type="radio" id="conf" name="conf" value="stop-route-local" checked="true">stop route local<br>';
} else {
   echo '<input type="radio" id="conf" name="conf" value="stop-route-local">stop route local<br>';
}
?>
<button type="submit">Submit</button>
</form>

