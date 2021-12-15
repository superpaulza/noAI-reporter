<?php
	$host = "localhost";
	$username = "wittaya";
	$password = "@u7WuW9m9n1h9B3nK";
	$dbname = "wittaya";

	$conn = new mysqli($host, $username, $password, $dbname);
	if ($conn) {
		$conn->set_charset("utf8");
		//echo "Done";
	} else {
		//echo "failed";
	}
?>
