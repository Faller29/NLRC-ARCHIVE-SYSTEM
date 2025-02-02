<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json'); 

$con = dbconnection(); 

$query = "SELECT sack_id, sack_name, arbiter_number FROM tbl_sack"; 
$result = mysqli_query($con, $query);

if (!$result) {
   
    echo json_encode(['error' => 'Failed to execute query: ' . mysqli_error($con)]);
    exit;
}

$data = []; 

while ($row = mysqli_fetch_assoc($result)) {
    
    $data[] = $row;
}

echo json_encode($data); 

mysqli_close($con); 
?>