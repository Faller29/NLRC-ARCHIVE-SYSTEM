<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json'); 

$con = dbconnection(); 

$query = isset($_GET['Query']) ? $_GET['Query'] : ''; 
$user = isset($_GET['User']) ? $_GET['User'] : null; // Add user parameter
$arbi = isset($_GET['arbi']) ? $_GET['arbi'] : null; // Add user parameter


$sql = "SELECT 
            s.sack_id, 
            s.sack_name, 
            s.arbiter_number,
            d.doc_id, 
            d.doc_complainant, 
            d.doc_respondent, 
            d.version, 
            d.status AS doc_status, 
            d.verdict, 
            d.volume,
            d.doc_number
        FROM tbl_document d
        JOIN tbl_sack s ON s.sack_id = d.sack_id
        WHERE s.status = 'Stored' AND d.status != 'Disposed'";

// Modify query based on user
if ($user != null) {
    $sql .= " AND s.arbiter_number = '$user'";
}

 if ($query != '') {
    $escapedQuery = mysqli_real_escape_string($con, $query);
    $sql .= " AND (
        d.doc_number LIKE '%$escapedQuery%' 
        OR d.doc_complainant LIKE '%$escapedQuery%' 
        OR d.doc_respondent LIKE '%$escapedQuery%'
        OR s.sack_name LIKE '%$escapedQuery%'

    )";
} 

if ($arbi != null && $user == null) {
    $escapedQuery = mysqli_real_escape_string($con, $query);
    $escapedArbi = mysqli_real_escape_string($con, $arbi);

    $sql .= " AND s.arbiter_number LIKE '%$escapedArbi%'";
}

$result = mysqli_query($con, $sql);

$data = [];

while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode($data);

mysqli_close($con);
?>
