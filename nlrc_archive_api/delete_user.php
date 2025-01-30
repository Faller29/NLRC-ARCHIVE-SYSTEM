<?php
include('setConnection/db_connection.php');

header('Content-Type: application/json');

$con = dbconnection(); 

$accountId = isset($_POST['acc_id']) ? (int) $_POST['acc_id'] : 0;

if ($accountId > 0) {
    $query = "DELETE FROM tbl_user_account WHERE acc_id = '$accountId'";

    if (mysqli_query($con, $query)) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($con)]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid account ID']);
}

mysqli_close($con);
?>
