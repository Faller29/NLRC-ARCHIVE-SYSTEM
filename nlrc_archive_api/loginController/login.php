<?php
include("../setConnection/db_connection.php");
$con = dbconnection();

if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = mysqli_real_escape_string($con, $_POST['username']);
    $password = mysqli_real_escape_string($con, $_POST['password']);

    
    $sql = "
        SELECT u.arbi_id, a.arbi_name, a.room, u.acc_id
        FROM tbl_user_account u
        LEFT JOIN tbl_arbi_user a ON u.arbi_id = a.arbi_id
        WHERE u.username = '$username' AND u.password = '$password'
    ";

    $result = mysqli_query($con, $sql);

    if (!$result) {
        die(json_encode(["error" => "Query execution failed: " . mysqli_error($con)]));
    }

    $count = mysqli_num_rows($result);

    if ($count == 1) {
        $row = mysqli_fetch_assoc($result);
        $arbi_id = $row['arbi_id'];
        $arbi_name = $row['arbi_name'];
        $room = $row['room'];
        $acc_id = $row['acc_id'];


        echo json_encode([
            "status" => "Success",
            "arbi_id" => $arbi_id,
            "arbi_name" => $arbi_name,
            "room" => $room,
            "acc_id" => $acc_id
            
        ]);
    } else {
        echo json_encode(["status" => "Error"]);
    }
} else {
    echo json_encode(["status" => "Invalid request. Username and password are required."]);
}

mysqli_close($con);
?>
