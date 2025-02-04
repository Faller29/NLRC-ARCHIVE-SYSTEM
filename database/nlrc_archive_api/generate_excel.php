<?php
include('setConnection/db_connection.php'); 
$con = dbconnection();

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $selectedArbiter = $_POST['selectedArbiter2'] ?? '';

    if (empty($selectedArbiter)) {
        echo json_encode(["error" => "Arbiter number is required"]);
        exit();
    }

    // Fetch matching sacks
    $sackQuery = "SELECT sack_id, sack_name FROM tbl_sack WHERE arbiter_number = ?";
    $stmt = $con->prepare($sackQuery);
    $stmt->bind_param("s", $selectedArbiter);
    $stmt->execute();
    $result = $stmt->get_result();

    $sacks = [];

    while ($sack = $result->fetch_assoc()) {
        $sackId = $sack['sack_id'];
        $sackName = $sack['sack_name'];

        // Fetch related documents
        $docQuery = "SELECT doc_number, doc_complainant, doc_respondent, volume, verdict, version FROM tbl_document WHERE sack_id = ?";
        $stmt2 = $con->prepare($docQuery);
        $stmt2->bind_param("s", $sackId);
        $stmt2->execute();
        $docResult = $stmt2->get_result();

        $documents = [];
        while ($doc = $docResult->fetch_assoc()) {
            $documents[] = $doc;
        }

        $stmt2->close(); // Close statement inside the loop

        // **Exclude sacks without documents**
        if (!empty($documents)) {
            $sacks[] = [
                "sack_name" => $sackName,
                "documents" => $documents
            ];
        }
    }

    $stmt->close(); // Close main statement
    $con->close();  // Close DB connection

    echo json_encode($sacks);
} else {
    echo json_encode(["error" => "Invalid request method"]);
}