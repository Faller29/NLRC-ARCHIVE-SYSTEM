<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    
    $sql = "SELECT a.arbi_id, a.arbi_name, a.room, u.username, u.password 
            FROM tbl_arbi_user a
            JOIN tbl_user_account u ON a.arbi_id = u.arbi_id";  
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
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>
