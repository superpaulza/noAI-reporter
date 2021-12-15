<?php
    require 'conn.php';
    $json = file_get_contents('php://input');

    $obj = json_decode($json, true, JSON_UNESCAPED_UNICODE);

    $usr = $obj['username'];

    $getRecord = "select report.case_id, car_classes.car_type, report.car_brand,  
    report.car_color, report.lic_plate, report.lic_issuer, report.details,
    report.location, report.case_datetime, report.picture, report.comment,
    status.name as status
    from report 
    inner join users on usr_id = reporter
    inner join car_classes on class_id = car_class
    inner join status on status_id = status
    where username = '$usr' ";

    $data = $conn->query($getRecord);

    $res = array();

    while($row = $data->fetch_assoc()) {
        $res[] = $row;
    }

    echo json_encode($res, JSON_UNESCAPED_UNICODE);
?>
