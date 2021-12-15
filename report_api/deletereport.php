<?php
    require "conn.php";

    $case_id = $_POST['case_id'];
    
    $sqlQuery = "DELETE FROM report WHERE case_id = '$case_id'";
    
    $data = $conn->query($sqlQuery);
    
    if(!$data) {
        echo "Error: " . $conn -> error;
    } else {
        echo "Sucessfully to delete data!";
    }
    
?>