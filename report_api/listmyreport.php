<?php
    require "conn.php";

    $usr = $_POST['username'];
    $sqlQuery = "select report.case_id, car_classes.car_type, report.car_brand,  
                        report.car_color, report.lic_plate, report.lic_issuer, report.details,
                        report.location_name, report.location_lat, report.location_long, report.case_datetime, report.report_datetime, report.picture as pictureUrl, report.comment,
                        status.name as status, users.first_name, users.last_name
                        from report 
                        inner join users on usr_id = reporter
                        inner join car_classes on class_id = car_class
                        inner join status on status_id = status
                        where username = '$usr'";
                        
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