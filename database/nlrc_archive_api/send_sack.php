<?php
include("setConnection/db_connection.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $sack_id = $_POST['sack_id'] ?? null;

    if (empty($sack_id)) {
        echo json_encode(["status" => "error", "message" => "Sack ID is required"]);
        exit;
    }

    $con = dbconnection();
    $stmt = $con->prepare("UPDATE tbl_sack SET status = 'Pending' WHERE sack_id = ?");
    $stmt->bind_param("i", $sack_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Sack status updated to pending"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to update sack status"]);
    }

    $stmt->close();
    $con->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>