<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['arbi_id'])) {
        $arbi_id = $_POST['arbi_id'];

        
        $sql_user = "DELETE FROM tbl_user_account WHERE arbi_id = $arbi_id";
        $conn->query($sql_user);

        
        $sql_arbi = "DELETE FROM tbl_arbi_user WHERE arbi_id = $arbi_id";
        if ($conn->query($sql_arbi) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Arbiter and associated user account(s) deleted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to delete arbiter"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing arbiter ID"]);
    }
}

$conn->close();
?>
