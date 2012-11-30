<?php

if(isset($_REQUEST['submit']) && $_REQUEST['submit']<>'')
{
 
 $username=$_REQUEST['user'];
 $password=$_REQUEST['password'];
 
 if($username=='admin' && $password=='t#$t#r')
 { 
	 header('Location:abc.php');
 }
 else
 {
	 $_SESSION['MSG']='Wrong User Name and Password'; 
 }
 
}

?>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Login Page</title>
</head>

<body bgcolor="#CCCCCC">
<form id="" name="" method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
<table width="339" border="1" align="center" style="font-weight:bold; background-color:#369; color:#FFF;">
  <tr>
    <td width="102" align="left">User Name</td>
    <td width="42" align="center">:</td>
    <td width="173"><input type="text" name="user" id="user" /></td>
  </tr>
  <tr>
    <td align="left">Password</td>
    <td align="center">:</td>
    <td><input type="password" name="password" id="password" /></td>
  </tr>
  <tr>
    <td colspan="3" align="center" style="color:#FFF;">
    	<?php 
			if(isset($_SESSION['MSG']) && $_SESSION['MSG']<>'')
			{
				echo $_SESSION['MSG'];
				unset($_SESSION['MSG']);
			}
		?>
    </td>
  </tr>
  <tr>
    <td colspan="3" align="center">
    <input type="submit" name="submit" value="Login" id="submit" />
    <input type="reset" name="reset" id="reset" value="Reset" />
    </td>
  </tr>
</table>
</form>



</body>
</html>