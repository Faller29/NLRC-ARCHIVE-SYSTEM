<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json'); 


$con = dbconnection(); 


$query = isset($_GET['Query']) ? $_GET['Query'] : ''; 


$sql = "SELECT s.sack_id, s.sack_name, d.doc_id, d.doc_title, d.status AS doc_status, d.verdict
        FROM tbl_document d
        JOIN tbl_sack s ON s.sack_id = d.sack_id
        WHERE s.status = 'Stored'";  


if ($query != '') {
    $sql .= " AND d.doc_title LIKE '%" . mysqli_real_escape_string($con, $query) . "%'";
}

$result = mysqli_query($con, $sql);


$data = [];


while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}


echo json_encode($data);

mysqli_close($con);
?>
