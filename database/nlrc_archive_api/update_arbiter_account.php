<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['arbi_id'], $_POST['name'], $_POST['room'], $_POST['username'], $_POST['password'])) {
        $arbi_id = $_POST['arbi_id'];
        $name = $_POST['name'];
        $room = $_POST['room'];
        $username = $_POST['username'];
        $password = $_POST['password'];

        
        $sql_arbi = "UPDATE tbl_arbi_user SET arbi_name = '$name', room = '$room' WHERE arbi_id = $arbi_id";
        
        if ($conn->query($sql_arbi) === TRUE) {
            
            $sql_account = "UPDATE tbl_user_account SET username = '$username', password = '$password' WHERE arbi_id = $arbi_id";

            if ($conn->query($sql_account) === TRUE) {
                echo json_encode(["status" => "success", "message" => "Arbiter updated successfully"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to update account: " . $conn->error]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to update arbiter: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>
