<?php
include('setConnection/db_connection.php');

header('Content-Type: application/json');

$con = dbconnection();

$accountId = isset($_POST['acc_id']) ? (int) $_POST['acc_id'] : 0;
$username = isset($_POST['username']) ? mysqli_real_escape_string($con, $_POST['username']) : '';
$password = isset($_POST['password']) ? mysqli_real_escape_string($con, $_POST['password']) : '';
$arbiId = isset($_POST['arbi_id']) && $_POST['arbi_id'] !== 'null' ? (int) $_POST['arbi_id'] : NULL;

if ($accountId > 0 && !empty($username)) {
    // Update query
    $query = "UPDATE tbl_user_account 
              SET username = '$username', password = '$password', arbi_id = " . ($arbiId === NULL ? 'NULL' : $arbiId) . " 
              WHERE acc_id = '$accountId'";

    if (mysqli_query($con, $query)) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($con)]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid data']);
}

mysqli_close($con);
?>
