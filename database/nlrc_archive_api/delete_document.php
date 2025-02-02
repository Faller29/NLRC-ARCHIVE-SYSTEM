<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['doc_id'])) {
        $doc_id = $_POST['doc_id'];

        $sql = "DELETE FROM tbl_document WHERE doc_id = $doc_id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Document deleted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to delete document"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing document ID"]);
    }
}

$conn->close();
?>