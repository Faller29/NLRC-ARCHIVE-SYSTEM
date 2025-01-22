<?php

include("setConnection/db_connection.php");


$conn = dbconnection();
if (!$conn) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . mysqli_connect_error()]);
    exit;
}


if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sack_id = $_GET['sack_id'] ?? null;

    
    if (empty($sack_id)) {
        echo json_encode(['status' => 'error', 'message' => 'sack_id is required']);
        exit;
    }

    
    $sql = "SELECT doc_title, doc_number FROM tbl_document WHERE sack_id = ?";
    $stmt = mysqli_prepare($conn, $sql);

    if ($stmt) {
        
        mysqli_stmt_bind_param($stmt, "i", $sack_id);

        
        mysqli_stmt_execute($stmt);

        
        mysqli_stmt_bind_result($stmt, $doc_title, $doc_number);

        
        $documents = [];
        while (mysqli_stmt_fetch($stmt)) {
            $documents[] = [
                'doc_title' => $doc_title,
                'doc_number' => $doc_number,
            ];
        }

        
        if (!empty($documents)) {
            echo json_encode(['status' => 'success', 'data' => $documents]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'No documents found for the given sack_id']);
        }

        
        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'SQL error: ' . mysqli_error($conn)]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}


mysqli_close($conn);
?>