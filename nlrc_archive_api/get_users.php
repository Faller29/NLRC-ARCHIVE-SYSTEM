<?php
include('setConnection/db_connection.php'); 

header('Content-Type: application/json');

$con = dbconnection();

$query = "
    SELECT ua.acc_id, ua.username, ua.password, ua.arbi_id, 
           COALESCE(au.arbi_name, 'Admin Account') AS arbi_name
    FROM tbl_user_account ua
    LEFT JOIN tbl_arbi_user au ON ua.arbi_id = au.arbi_id
";

$result = mysqli_query($con, $query);

if (!$result) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to execute query: ' . mysqli_error($con)]);
    exit;
}

$accounts = [];

while ($row = mysqli_fetch_assoc($result)) {
    $accounts[] = $row;
}

echo json_encode(['status' => 'success', 'accounts' => $accounts]);

mysqli_close($con);
?>
