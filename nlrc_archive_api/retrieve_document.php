<?php
// Include the database connection function
include("setConnection/db_connection.php");

// Establish the connection
$conn = dbconnection();
if (!$conn) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . mysqli_connect_error()]);
    exit;
}

// Handle GET request
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sack_id = $_GET['sack_id'] ?? null;

    // Validate sack_id
    if (empty($sack_id)) {
        echo json_encode(['status' => 'error', 'message' => 'sack_id is required']);
        exit;
    }

    // Fetch documents associated with the sack_id
    $sql = "SELECT doc_title, doc_number FROM tbl_document WHERE sack_id = ?";
    $stmt = mysqli_prepare($conn, $sql);

    if ($stmt) {
        // Bind the parameter
        mysqli_stmt_bind_param($stmt, "i", $sack_id);

        // Execute the statement
        mysqli_stmt_execute($stmt);

        // Bind the result variables
        mysqli_stmt_bind_result($stmt, $doc_title, $doc_number);

        // Fetch data
        $documents = [];
        while (mysqli_stmt_fetch($stmt)) {
            $documents[] = [
                'doc_title' => $doc_title,
                'doc_number' => $doc_number,
            ];
        }

        // Check if documents are found
        if (!empty($documents)) {
            echo json_encode(['status' => 'success', 'data' => $documents]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'No documents found for the given sack_id']);
        }

        // Close the statement
        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'SQL error: ' . mysqli_error($conn)]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

// Close the connection
mysqli_close($conn);
?>