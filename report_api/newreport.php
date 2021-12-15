<?php
    require "conn.php";

    $car_class = $_POST['car_class'];
    $car_brand = $_POST['car_brand'];
    $car_color = $_POST['car_color'];
    $lic_plate = $_POST['lic_plate'];
    $lic_issuer = $_POST['lic_issuer'];
    $details = $_POST['details'];
    $location_name = $_POST['location_name'];
    $location_lat = $_POST['location_lat'];
    $location_long = $_POST['location_long'];
    $case_datetime = $_POST['case_datetime'];
    $report_datetime = $_POST['report_datetime'];
    $reporter = $_POST['reporter'];

    $image = $_POST['image'];
    $name = $_POST['name'];
    
    $getUserId = "select usr_id from users where username = '$reporter'";
    
    $userId = $conn->query($getUserId);
    
    if(!$userId) {
        echo "Error: " . $conn -> error;
    } else {
        $reporter = $userId->fetch_assoc()["usr_id"];
        $realImage = base64_decode($image);
        file_put_contents("./imageData/$name", $realImage);
        $sqlQuery = "insert INTO report VALUES(null, timestamp '$report_datetime', timestamp '$case_datetime', '$car_class', '$car_brand', '$car_color', '$lic_plate', '$lic_issuer', '$details', '$location_name', '$location_lat', '$location_long', '$reporter', 'http://home112.ddns.net/report_api/imageData/$name', '1', '')";
        if(!$conn->query($sqlQuery)) {
             echo "Error: " . $conn -> error;
         } else {
             echo "Sucessfully to add data!";
         }
    }
    
?>
