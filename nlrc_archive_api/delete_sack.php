<?php
include ("setConnection/db_connection.php"); 

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();

    $sack_id = $_POST['sack_id'];

    // Check if sack_id is provided
    if (empty($sack_id)) {
        echo json_encode([
            "status" => "error",
            "message" => "Sack ID is required"
        ]);
        exit();
    }

    // Prepare and execute the delete query
    $query = "DELETE FROM tbl_sack WHERE sack_id = ?";
    $stmt = $con->prepare($query);
    $stmt->bind_param("i", $sack_id);

    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success",
            "message" => "Sack deleted successfully"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to delete sack"
        ]);
    }

    $stmt->close();
    $con->close();
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}
?>