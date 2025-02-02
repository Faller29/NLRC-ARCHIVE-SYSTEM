<?php
include('setConnection/db_connection.php');

header('Content-Type: application/json');

$con = dbconnection();

$username = $_POST['username'];
$password = $_POST['password'];
$arbi_id = $_POST['arbi_id'];

if ($arbi_id == 'NULL' || $arbi_id === '') {
    $arbi_id = null;
} else {
    $arbi_id = (int)$arbi_id;
}

if (empty($username) || empty($password)) {
    echo json_encode(['status' => 'error', 'message' => 'Username and password are required']);
    exit;
}

$query = "INSERT INTO tbl_user_account (username, password, arbi_id) VALUES ('$username', '$password', " . ($arbi_id === null ? 'NULL' : $arbi_id) . ")";
$result = mysqli_query($con, $query);

if (!$result) {
    echo json_encode(['status' => 'error', 'message' => 'MySQL Error: ' . mysqli_error($con)]);
    exit;
} else {
    echo json_encode(['status' => 'success', 'message' => 'Account added successfully']);
}

mysqli_close($con);
?>
