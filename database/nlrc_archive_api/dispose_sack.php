<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['sack_id'])) {
        $sack_id = (int)$_POST['sack_id']; 

        $conn->begin_transaction();

        // Update status of all documents linked to the sack_id
        $sql_update = "UPDATE tbl_document 
                       SET status = 'Disposed' 
                       WHERE sack_id = ? 
                       AND (status = 'Stored' OR status = 'Retrieved')";

        if ($stmt_update = $conn->prepare($sql_update)) {
            $stmt_update->bind_param("i", $sack_id);

            if ($stmt_update->execute()) {
                if ($stmt_update->affected_rows > 0) {
                    $conn->commit();
                    echo json_encode(["status" => "success", "message" => "Documents linked to the sack have been disposed of successfully"]);
                } else {
                    echo json_encode(["status" => "error", "message" => "No documents found with status 'Stored' or 'Retrieved' for this sack"]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to update document statuses"]);
            }
            $stmt_update->close();
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to prepare update query for tbl_document"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing sack ID"]);
    }
}

$conn->close();
?>
