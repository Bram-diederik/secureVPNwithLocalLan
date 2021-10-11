<?php
namespace Phppot;

class Member
{

    private $dbConn;

    private $ds;

    function __construct()
    {
    }

    function getMemberById($memberId)
    {
        return $memberResult;
    }
    
    public function processLogin($username, $password) {
        if ($username == "login" && $password == "pass")
         $_SESSION["userId"] = 1;
         return true;
    }
}
