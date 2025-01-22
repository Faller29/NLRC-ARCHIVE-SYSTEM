<?php
include("setConnection/db_connection.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $sack_name = $_POST['sack_name']; 
    $arbiter_number = $_POST['arbiter_number']; // Get the arbiter_number from the request

    if (empty($sack_name) || empty($arbiter_number)) {
        echo json_encode(["status" => "error", "message" => "Sack name and Arbiter number are required."]);
        exit;
    }

    $con = dbconnection();
    $stmt = $con->prepare("INSERT INTO tbl_sack (sack_name, arbiter_number) VALUES (?, ?)");
    $stmt->bind_param("ss", $sack_name, $arbiter_number);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Sack added successfully.", "sack_id" => $stmt->insert_id]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add sack."]);
    }

    $stmt->close();
    $con->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>