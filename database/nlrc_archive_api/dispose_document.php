<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['doc_id'])) {
        $doc_id = (int)$_POST['doc_id']; 

        $conn->begin_transaction();

        $sql_update = "UPDATE tbl_document 
                       SET status = 'Disposed' 
                       WHERE doc_id = ? 
                       AND (status = 'Stored' OR status = 'Retrieved')";

        if ($stmt_update = $conn->prepare($sql_update)) {
            $stmt_update->bind_param("i", $doc_id);

            if ($stmt_update->execute()) {
                if ($stmt_update->affected_rows > 0) {
                    $conn->commit();
                    echo json_encode(["status" => "success", "message" => "Document status updated successfully"]);
                } else {
                    echo json_encode(["status" => "error", "message" => "No document found with status 'Stored' or 'Retrieved'"]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to update document status"]);
            }
            $stmt_update->close();
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to prepare update query for tbl_document"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing document ID"]);
    }
}

$conn->close();
?>
