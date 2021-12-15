<?php
    require "conn.php";

    $lic_plate = $_POST['lic_plate'];
	$lic_issuer = $_POST['lic_issuer'];
	
    $sqlQuery = "select report.case_id, car_classes.car_type, report.car_brand,  
report.car_color, report.lic_plate, report.lic_issuer, report.details,
report.location_name, report.case_datetime, report.picture, report.comment,
status.name as status
from report
inner join car_classes on class_id = car_class
inner join status on status_id = status
                        where lic_plate = '$lic_plate' OR lic_issuer = '$lic_issuer'";
                        
    $data = $conn->query($sqlQuery);
    if(!$data) {
        echo "Error: " . $conn -> error;
    } else {
        $rows = array();
        while($r = mysqli_fetch_assoc($data)) {
            $rows[] = $r;
        }
        echo json_encode($rows);
    }
    
?>