<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['doc_id'])) {
        $doc_id = (int)$_POST['doc_id'];
        $sql = "UPDATE tbl_document SET status = 'Request' WHERE doc_id = ? AND status = 'Stored'";

        if ($stmt = $conn->prepare($sql)) {
            $stmt->bind_param("i", $doc_id); 

            if ($stmt->execute()) {
                if ($stmt->affected_rows > 0) {
                    echo json_encode(["status" => "success", "message" => "Document status updated to 'Retrieved'"]);
                } else {
                    echo json_encode(["status" => "error", "message" => "No document found with status 'Stored'"]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to update document status"]);
            }
            $stmt->close();
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to prepare SQL query"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing document ID"]);
    }
}

$conn->close();
?>
