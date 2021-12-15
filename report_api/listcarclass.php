<?php
    require "conn.php";

    $sqlQuery = "select * from car_classes";
                        
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