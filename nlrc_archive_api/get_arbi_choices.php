<?php
include("setConnection/db_connection.php");
$con = dbconnection();

function getArbiters() {
    global $con;

    $sql = "SELECT arbi_id, arbi_name FROM tbl_arbi_user";
    $result = mysqli_query($con, $sql);

    if (!$result) {
        die(json_encode(["error" => "Query execution failed: " . mysqli_error($con)]));
    }

    $arbiters = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $arbiters[] = [
            'arbi_id' => $row['arbi_id'],
            'arbi_name' => $row['arbi_name']
        ];
    }

    echo json_encode($arbiters);
}

getArbiters();
mysqli_close($con);
?>
