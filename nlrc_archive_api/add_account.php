<?php
include("setConnection/db_connection.php");
$con = dbconnection();

if (!$con) {
    die(json_encode(["error" => "Database Connection Failed"]));
}

if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = mysqli_real_escape_string($con, $_POST['username']);
    $password = mysqli_real_escape_string($con, $_POST['password']);

    
    $sql = "SELECT * FROM tbl_user_account WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($con, $sql);

    if (!$result) {
        die(json_encode(["error" => "Query execution failed: " . mysqli_error($con)]));
    }

    $count = mysqli_num_rows($result);

    if ($count == 1) {
        echo json_encode("Error"); 
    } else {
        
        $insert = "INSERT INTO tbl_user_account (username, password) VALUES ('$username', '$password')";
        $query = mysqli_query($con, $insert);

        if ($query) {
            echo json_encode("Success");
        } else {
            echo json_encode(["error" => "Failed to register user: " . mysqli_error($con)]);
        }
    }
} else {
    echo json_encode(["error" => "Invalid request. Username and password are required."]);
}

mysqli_close($con);
?>