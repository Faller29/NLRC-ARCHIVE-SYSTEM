<?php
include("setConnection/db_connection.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $sack_name = $_POST['sack_name']; 
    $arbiter_number = $_POST['arbiter_number']; 
    $sack_status = $_POST['sack_status']; 
    $acc_id = (int) $_POST['acc_id']; 
    $proceed = isset($_POST['proceed']) ? $_POST['proceed'] : 'false';  

    if (empty($sack_name) || empty($arbiter_number)) {
        echo json_encode(["status" => "error", "message" => "Sack name and Arbiter number are required."]);
        exit;
    }

    // Connect to the database
    $con = dbconnection();

    $stmt = $con->prepare("SELECT COUNT(*) FROM tbl_sack WHERE sack_name = ? AND arbiter_number = ?");
    $stmt->bind_param("ss", $sack_name, $arbiter_number);
    $stmt->execute();
    $stmt->bind_result($count);
    $stmt->fetch();
    $stmt->close();

    if ($count > 0 && $proceed == 'false') {
        echo json_encode(["status" => "error", "message" => "Sack name already exists for this arbiter. Please choose a different name."]);
        $con->close();
        exit;
    }

    $stmt = $con->prepare("INSERT INTO tbl_sack (sack_name, arbiter_number, status, acc_id) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $sack_name, $arbiter_number, $sack_status, $acc_id);  

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
