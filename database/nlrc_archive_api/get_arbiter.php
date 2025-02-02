<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json');

$con = dbconnection();

$query = "SELECT arbi_id, arbi_name, room FROM tbl_arbi_user";
$result = mysqli_query($con, $query);

if (!$result) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to execute query: ' . mysqli_error($con)]);
    exit;
}

$arbiters = [];

while ($row = mysqli_fetch_assoc($result)) {
    $arbiters[] = $row;
}

echo json_encode(['status' => 'success', 'arbiters' => $arbiters]);

mysqli_close($con);
?>
