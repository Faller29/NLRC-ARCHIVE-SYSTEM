<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json'); 

$con = dbconnection(); 

$query = isset($_GET['Query']) ? $_GET['Query'] : ''; 

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
        WHERE s.status = 'Stored'";  

if ($query != '') {
    $escapedQuery = mysqli_real_escape_string($con, $query);
    $sql .= " AND (
        d.doc_number LIKE '%$escapedQuery%' 
        OR d.doc_complainant LIKE '%$escapedQuery%' 
        OR d.doc_respondent LIKE '%$escapedQuery%'
    )";
}

$result = mysqli_query($con, $sql);

$data = [];

while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode($data);

mysqli_close($con);
?>
