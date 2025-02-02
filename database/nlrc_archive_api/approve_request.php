<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json');

$con = dbconnection();

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['doc_id']) || !isset($data['new_status'])) {
    echo json_encode(['error' => 'Invalid request, missing parameters']);
    exit;
}

$doc_id = $data['doc_id'];
$new_status = $data['new_status'];

$query = "UPDATE tbl_document SET status = ? WHERE doc_id = ?";
$stmt = mysqli_prepare($con, $query);

if ($stmt) {
    mysqli_stmt_bind_param($stmt, "si", $new_status, $doc_id);
    if (mysqli_stmt_execute($stmt)) {
        if ($new_status === 'Stored') {
            $deleteQuery = "DELETE FROM tbl_archived WHERE doc_id = ?";
            $deleteStmt = mysqli_prepare($con, $deleteQuery);
            if ($deleteStmt) {
                mysqli_stmt_bind_param($deleteStmt, "i", $doc_id);
                if (mysqli_stmt_execute($deleteStmt)) {
                    echo json_encode(['success' => true, 'message' => 'Document status updated and removed from tbl_archived']);
                } else {
                    echo json_encode(['error' => 'Failed to delete document from tbl_archived']);
                }
                mysqli_stmt_close($deleteStmt);
            } else {
                echo json_encode(['error' => 'Failed to prepare delete statement for tbl_archived']);
            }
        } else {
            echo json_encode(['success' => true, 'message' => 'Document status updated successfully']);
        }
    } else {
        echo json_encode(['error' => 'Failed to update document status']);
    }
    mysqli_stmt_close($stmt);
} else {
    echo json_encode(['error' => 'Failed to prepare statement']);
}

mysqli_close($con);
?>
