<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['user_id'])) {
        $user_id = $_POST['user_id'];

        
        $sql = "DELETE FROM tbl_user_account WHERE acc_id = $user_id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "User account deleted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to delete user account"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing user ID"]);
    }
}

$conn->close();
?>
