<?php
include("setConnection/db_connection.php");
$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $sack_id = $_POST['sack_id'] ?? null;
    $doc_number = $_POST['doc_number'] ?? null;
    $doc_respondent = $_POST['doc_repondent'] ?? null;
    $doc_complainant = $_POST['doc_complainant'] ?? null;
    $doc_verdict = $_POST['doc_verdict'] ?? null;
    $doc_status = $_POST['status'] ?? null;
    $doc_version = $_POST['doc_version'] ?? null;
    $doc_volume = $_POST['doc_volume'] ?? null;



    if (empty($sack_id) || empty($doc_number) || empty($doc_complainant) || empty($doc_respondent)) {
        echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
        exit;
    }

  
    $sql = "INSERT INTO tbl_document (sack_id, doc_number, doc_complainant, doc_respondent, status, verdict, version, volume) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($conn, $sql);

    if ($stmt) {
      
        mysqli_stmt_bind_param($stmt, "isssssss", $sack_id, $doc_number, $doc_complainant, $doc_respondent, $doc_status, $doc_verdict, $doc_version, $doc_volume);

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