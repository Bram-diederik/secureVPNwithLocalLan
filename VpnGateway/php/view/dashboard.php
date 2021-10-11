<?php
namespace Phppot;

use \Phppot\Member;

if (! empty($_SESSION["userId"])) {
    require_once __DIR__ . './../class/Member.php';
    $member = new Member();
}
?>


<?php

if ($conf = $_POST["conf"])  {
#echo $conf;
  if ($conf == "stop") {
    shell_exec("sudo vpnadmin.sh stop");
  } else if ($conf == "stop-route-local") {
    shell_exec("sudo vpnadmin.sh stop route-local");
} else {
      shell_exec("sudo vpnadmin.sh start $conf");

}

}
?>
<html> 
<head> 
<script type="text/javascript"> 
function createRequestObject() {
     
        var req;
     
        if(window.XMLHttpRequest){
            // Firefox, Safari, Opera...
            req = new XMLHttpRequest();
        } else if(window.ActiveXObject) {
            // Internet Explorer 5+
            req = new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            // There is an error creating the object, just as an old 
            // browser is being used.
            alert('There was a problem creating the XMLHttpRequest object');
        } 
     
        return req;
     
    } 
     
    // Make the XMLHttpRequest object
    var http = createRequestObject();
     
    function sendRequest() {
        // Open PHP script for requests
        http.open('get', '/openvpn/taillog.php'); 
        http.onreadystatechange =  handleResponse; http.send(null);

     }
   function handleResponse() {
     
        if(http.readyState == 4 && http.status == 200){
     
            // Text returned FROM PHP script
            var response = http.responseText;
     
            if(response) {
                // UPDATE ajaxTest content
                document.getElementById("log").innerHTML = response; 
                setTimeout(update,1000);
            } 
     
        } 
    } 


    function update() { sendRequest();
    } 
</script> 

<title>Openvpn switcher</title>
<link href="./view/css/style.css" rel="stylesheet" type="text/css" />
<link rel='shortcut icon' href='/admin/img/favicons/favicon.ico' type='image/x-icon'>
</head>

<body onLoad="sendRequest()">
    <div>
        <div class="dashboard">
            <div class="member-dashboard">
<?php
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




<a href="./logout.php" class="logout-button">Logout</a>
            </div>
        </div>
<pre><span id="log" name="log"></span></pre>
    </div>
</body>
</html>
