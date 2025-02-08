<?php
include("setConnection/db_connection.php");
$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $doc_id = $_POST['doc_id'] ?? null;
    $sack_id = $_POST['sack_id'] ?? null;
    $doc_number = $_POST['doc_number'] ?? null;
    $doc_respondent = $_POST['doc_respondent'] ?? null;
    $doc_complainant = $_POST['doc_complainant'] ?? null;
    $doc_verdict = $_POST['doc_verdict'] ?? null;
    $doc_volume = $_POST['doc_volume'] ?? null;
    $missing_fields = [];
    if (empty($doc_id)) $missing_fields[] = 'doc_id';
    if (empty($sack_id)) $missing_fields[] = 'sack_id';
    if (empty($doc_number)) $missing_fields[] = 'doc_number';
    if (empty($doc_complainant)) $missing_fields[] = 'doc_complainant';
    if (empty($doc_respondent)) $missing_fields[] = 'doc_respondent';

    if (!empty($missing_fields)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Missing required fields: ' . implode(', ', $missing_fields)
        ]);
        exit;
    }

    $sql = "UPDATE tbl_document SET sack_id = ?, doc_number = ?, doc_complainant = ?, doc_respondent = ?,  verdict = ?, volume = ? WHERE doc_id = ?";
    $stmt = mysqli_prepare($conn, $sql);

    if ($stmt) {
        mysqli_stmt_bind_param($stmt, "isssssi", $sack_id, $doc_number, $doc_complainant, $doc_respondent, $doc_verdict, $doc_volume, $doc_id);

        if (mysqli_stmt_execute($stmt)) {
            echo json_encode(['status' => 'success', 'message' => 'Document updated successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to update document']);
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
