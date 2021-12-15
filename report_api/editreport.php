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
    $case_id = $_POST['case_id'];
    $status = $_POST['status'];
    
    $sqlQuery = "UPDATE report SET report_datetime = TIMESTAMP '$report_datetime', case_datetime = TIMESTAMP '$case_datetime', 
                    car_class = '$car_class', car_brand = '$car_brand', car_color = '$car_color', lic_plate = '$lic_plate', lic_issuer = '$lic_issuer',
                    details = '$details', location_name = '$location_name', location_lat = '$location_lat', location_long = '$location_long',
                    reporter = '$reporter', status = '$status' WHERE case_id = '$case_id'";
    
    $data = $conn->query($sqlQuery);
    
    if(!$data) {
        echo "Error: " . $conn -> error;
    } else {
        echo "Sucessfully to update data!";
    }
    
?>