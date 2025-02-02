<?php
include('setConnection/db_connection.php'); 

$con = dbconnection(); 


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $sack_id = $_POST['sack_id'] ?? null;
    
    if ($sack_id) {
        
        $query = "UPDATE tbl_sack SET status = 'Stored' WHERE sack_id = ? AND status = 'Pending'"; 

        
        $stmt = mysqli_prepare($con, $query);
        mysqli_stmt_bind_param($stmt, "i", $sack_id);

        if (mysqli_stmt_execute($stmt)) {
            echo json_encode(['success' => true, 'message' => 'Sack status updated to Stored.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to update sack status.']);
        }

        
        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid sack ID provided.']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
}


mysqli_close($con);
?>