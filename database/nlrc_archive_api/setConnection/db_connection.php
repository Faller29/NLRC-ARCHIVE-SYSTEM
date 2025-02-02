<?php

function dbconnection() {
    $con = mysqli_connect("localhost", "root", "", "nlrc_archive");

    if (!$con) {
        die("Database connection failed: " . mysqli_connect_error());
    }

    return $con;
}
?>