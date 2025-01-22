<?php
include("../setConnection/db_connection.php");
$con = dbconnection();

if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = mysqli_real_escape_string($con, $_POST['username']);
    $password = mysqli_real_escape_string($con, $_POST['password']);

    $sql = "SELECT * FROM tbl_user_account WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($con, $sql);

    if (!$result) {
        die(json_encode(["error" => "Query ex
        ecution failed: " . mysqli_error($con)]));
    }

    $count = mysqli_num_rows($result);

    if ($count == 1) {
        echo json_encode("Success");
    } else {
        echo json_encode("Error");
    }
} else {
    echo json_encode("Invalid request. Username and password are required.");
}

mysqli_close($con);
?>