<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json'); 

$con = dbconnection(); 

$user = isset($_GET['user']) ? $_GET['user'] : null;

$query = "SELECT sack_id, sack_name, arbiter_number 
          FROM tbl_sack 
          WHERE status = 'Pending'";

if (!empty($user)) {
    $query .= " AND arbiter_number = ?";
}

$stmt = $con->prepare($query);

if (!empty($user)) {
    $stmt->bind_param("s", $user);
}

$stmt->execute();
$result = $stmt->get_result();

if (!$result) {
    echo json_encode(['error' => 'Failed to execute query: ' . $con->error]);
    exit;
}

$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);

mysqli_close($con); 
?>
