<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['doc_id']) && isset($_POST['acc_id'])) {
        $doc_id = (int)$_POST['doc_id']; 
        $accountId = (int)$_POST['acc_id']; 

        $conn->begin_transaction();

        $sql_update = "UPDATE tbl_document SET status = 'Disposed' WHERE doc_id = ? AND (status = 'Stored' OR status = 'Retrieved')";

        if ($stmt_update = $conn->prepare($sql_update)) {
            $stmt_update->bind_param("i", $doc_id);

            if ($stmt_update->execute()) {
                if ($stmt_update->affected_rows > 0) {

                    $sql_insert = "INSERT INTO tbl_archived (acc_id, doc_id) VALUES (?, ?)";
                    
                    if ($stmt_insert = $conn->prepare($sql_insert)) {
                        $stmt_insert->bind_param("ii", $accountId, $doc_id);
                        
                        if ($stmt_insert->execute()) {
                            $conn->commit();
                            echo json_encode(["status" => "success", "message" => "Document status updated and archived successfully"]);
                        } else {
                            $conn->rollback();
                            echo json_encode(["status" => "error", "message" => "Failed to add the document to tbl_archived"]);
                        }

                        $stmt_insert->close();
                    } else {
                        $conn->rollback();
                        echo json_encode(["status" => "error", "message" => "Failed to prepare insert query for tbl_archived"]);
                    }
                } else {
                    echo json_encode(["status" => "error", "message" => "No document found with status 'Stored'"]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to update document status"]);
            }
            $stmt_update->close();
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to prepare update query for tbl_document"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing document ID or accountId"]);
    }
}

$conn->close();
?>
