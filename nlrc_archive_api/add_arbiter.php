<?php
include('setConnection/db_connection.php');

header('Content-Type: application/json');
$con = dbconnection();

$arbi_name = isset($_POST['arbi_name']) ? trim($_POST['arbi_name']) : '';
$room = isset($_POST['room']) ? trim($_POST['room']) : '';

if (empty($arbi_name) || empty($room)) {
    echo json_encode(['status' => 'error', 'message' => 'Missing fields']);
    exit;
}

$query = "INSERT INTO tbl_arbi_user (arbi_name, room) VALUES (?, ?)";
$stmt = mysqli_prepare($con, $query);
mysqli_stmt_bind_param($stmt, "ss", $arbi_name, $room);

if (mysqli_stmt_execute($stmt)) {
    echo json_encode(['status' => 'success', 'message' => 'Arbiter added']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to add arbiter']);
}

mysqli_stmt_close($stmt);
mysqli_close($con);
?>


<?php
/*

include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['name'], $_POST['room'], $_POST['username'], $_POST['password'])) {
        $name = $_POST['name'];
        $room = $_POST['room'];
        $username = $_POST['username'];
        $password = $_POST['password'];

        
        $conn->begin_transaction();

        try {
            
            $sqlArbiter = "INSERT INTO tbl_arbi_user (arbi_name, room) VALUES ('$name', '$room')";
            if ($conn->query($sqlArbiter) === TRUE) {
                
                $arbi_id = $conn->insert_id;

                
                $sqlUserAccount = "INSERT INTO tbl_user_account (username, password, arbi_id) 
                                   VALUES ('$username', '$password', $arbi_id)";

                if ($conn->query($sqlUserAccount) === TRUE) {
                    
                    $conn->commit();
                    echo json_encode(["status" => "success", "message" => "Arbiter and account added successfully"]);
                } else {
                    
                    throw new Exception("Failed to add account: " . $conn->error);
                }
            } else {
                
                throw new Exception("Failed to add arbiter: " . $conn->error);
            }
        } catch (Exception $e) {
            
            $conn->rollback();
            echo json_encode(["status" => "error", "message" => $e->getMessage()]);
        }
    } else {
        
        echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();

*/
?>
