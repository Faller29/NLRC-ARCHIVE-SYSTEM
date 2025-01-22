<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $sql = "SELECT u.acc_id, u.username, u.password, a.arbi_id, a.arbi_name 
            FROM tbl_user_account u 
            JOIN tbl_arbi_user a ON u.arbi_id = a.arbi_id";
    
    $result = $conn->query($sql);

    $arbiters = [];
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $arbiters[] = $row;
        }
        echo json_encode(["status" => "success", "arbiters" => $arbiters]);
    } else {
        echo json_encode(["status" => "error", "message" => "No arbiters found"]);
    }
}

$conn->close();
?>
