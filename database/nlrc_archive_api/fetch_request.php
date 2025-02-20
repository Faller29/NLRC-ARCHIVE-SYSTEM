<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

$user = isset($_GET['user']) ? $_GET['user'] : null;

$sql = "SELECT 
    a.req_id, 
    a.timestamp, 
    s.sack_id, 
    s.sack_name, 
    s.arbiter_number,
    d.doc_id, 
    d.doc_complainant, 
    d.doc_respondent, 
    d.version, 
    d.verdict, 
    d.volume, 
    d.doc_number,
    u.username, 
    IFNULL(ar.arbi_name, 'admin') AS arbi_name  
FROM tbl_archived a
JOIN tbl_document d ON d.doc_id = a.doc_id
JOIN tbl_sack s ON s.sack_id = d.sack_id
JOIN tbl_user_account u ON u.acc_id = a.acc_id
LEFT JOIN tbl_arbi_user ar ON ar.arbi_id = u.arbi_id
WHERE d.status = 'Requested'";

if (!empty($user)) {
    $sql .= " AND s.arbiter_number = ?";
}

$stmt = $conn->prepare($sql);

if (!empty($user)) {
    $stmt->bind_param("s", $user);
}

$stmt->execute();
$result = $stmt->get_result();

$documents = [];

while ($row = $result->fetch_assoc()) {
    $documents[] = $row;
}

echo json_encode($documents);

$conn->close();
?>
