<?php

include("setConnection/db_connection.php");


$conn = dbconnection();


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $sack_id = $_POST['sack_id'] ?? null;
    $doc_number = $_POST['doc_number'] ?? null;
    $doc_title = $_POST['doc_title'] ?? null;


    if (empty($sack_id) || empty($doc_number) || empty($doc_title)) {
        echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
        exit;
    }

  
    $sql = "INSERT INTO tbl_document (sack_id, doc_number, doc_title) VALUES (?, ?, ?)";
    $stmt = mysqli_prepare($conn, $sql);

    if ($stmt) {
      
        mysqli_stmt_bind_param($stmt, "iss", $sack_id, $doc_number, $doc_title);

        if (mysqli_stmt_execute($stmt)) {
            echo json_encode(['status' => 'success', 'message' => 'Document added successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to add document']);
        }

        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to prepare the SQL statement']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}


mysqli_close($conn);
?>