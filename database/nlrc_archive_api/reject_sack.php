<?php
include('setConnection/db_connection.php'); 

$con = dbconnection(); 


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $sack_id = $_POST['sack_id'] ?? null;
    $reject_message = $_POST['reject_message'] ?? null;

    if ($sack_id && $reject_message) {
        
        $query = "UPDATE tbl_sack SET status = 'Reject', admin_message = ? WHERE sack_id = ? AND status = 'Pending'"; 

        
        $stmt = mysqli_prepare($con, $query);
        mysqli_stmt_bind_param($stmt, "si", $reject_message, $sack_id);

        if (mysqli_stmt_execute($stmt)) {
            echo json_encode(['success' => true, 'message' => 'Sack status updated to Rejected.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to reject sack status.']);
        }

        
        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid sack ID or missing reject message.']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
}


mysqli_close($con);
?>
