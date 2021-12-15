<?php
/* 
 //Define your Server host name here.
 $HostName = "localhost";
 
 //Define your MySQL Database Name here.
 $DatabaseName = "wittaya";
 
 //Define your Database User Name here.
 $HostUser = "wittaya";
 
 //Define your Database Password here.
 $HostPass = "@u7WuW9m9n1h9B3nK"; 

 // Creating MySQL Connection.
 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
*/
require 'conn.php';

 // Getting the received JSON into $json variable.
 $json = file_get_contents('php://input');
 
 // Decoding the received JSON and store into $obj variable.
 $obj = json_decode($json, true, JSON_UNESCAPED_UNICODE);
 
 // Getting User email from JSON $obj array and store into $email.
 $usr = $obj['username'];
 
 // Getting Password from JSON $obj array and store into $password.
 $passwords = $obj['passwords'];
 
 //Applying User Login query with email and password.
 $loginQuery = "select * from users where username = '$usr' and passwords = '$passwords' ";

 $roleQuery = "select role from users where username = '$usr' ";
 
 // Executing SQL Query.
 $check = mysqli_fetch_array(mysqli_query($conn,$loginQuery));
 
	if(isset($check)){
		
		 // Successfully Login Message.
		 $onLoginSuccess = 'Login Matched';

		 $role = $conn->query($roleQuery);

		 $arr = array('status' => $onLoginSuccess, 'role' => $role->fetch_assoc()["role"]);

			// Converting the message into JSON format.
		 $SuccessMSG = json_encode($arr, JSON_UNESCAPED_UNICODE);
		 
		 // Echo the message.
		 echo $SuccessMSG ; 
	 
	 }
	 
	 else{
	 
		 // If Email and Password did not Matched.
		$InvalidMSG = 'Invalid Username or Password Please Try Again' ;
		$arr = array('status' => $InvalidMSG);		 
		// Converting the message into JSON format.
		$InvalidMSGJSon = json_encode($arr, JSON_UNESCAPED_UNICODE);
		 
		// Echo the message.
		 echo $InvalidMSGJSon ;
	 
	 } 
?>
