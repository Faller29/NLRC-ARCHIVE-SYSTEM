<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json'); 

$con = dbconnection(); 

$accountId = isset($_GET['acc_id']) ? (int) $_GET['acc_id'] : 0;

if ($accountId > 0) {
    $query = "SELECT sack_id, sack_name, arbiter_number, status, admin_message
              FROM tbl_sack 
              WHERE acc_id = '$accountId' AND status IN ('Creating', 'Reject')";
} else {
    echo json_encode(['error' => 'Invalid or missing accountId']);
    exit;
}

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
