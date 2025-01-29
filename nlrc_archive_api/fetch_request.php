<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

// Fetch documents with 'Request' status
$sql = "SELECT doc_id, doc_name, doc_complainant, doc_respondent, verdict FROM tbl_document WHERE status = 'Request'";
$result = $conn->query($sql);

$documents = [];

while ($row = $result->fetch_assoc()) {
    $documents[] = $row;
}

echo json_encode($documents);

$conn->close();
?>
