<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['username'], $_POST['password'], $_POST['arbi_id'])) {
        $username = $_POST['username'];
        $password = $_POST['password']; 
        $arbi_id = $_POST['arbi_id'];

        
        $sql_check = "SELECT * FROM tbl_arbi_user WHERE arbi_id = $arbi_id";
        $result = $conn->query($sql_check);

        if ($result->num_rows == 0) {
            echo json_encode(["status" => "error", "message" => "Invalid arbiter ID"]);
            exit();
        }

        
        $sql = "INSERT INTO tbl_user_account (username, password, arbi_id) VALUES ('$username', '$password', $arbi_id)";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "User account created successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to create user account"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    }
}

$conn->close();
?>
