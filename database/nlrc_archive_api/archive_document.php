<?php
include("setConnection/db_connection.php");

$conn = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['doc_id'])) {
        // Get the document ID from the POST request
        $doc_id = (int)$_POST['doc_id'];

        // Start a transaction
        $conn->begin_transaction();

        try {
            // Fetch document details from tbl_document to prepare for insertion into tbl_archived
            $sql = "SELECT doc_id, doc_name, doc_complainant, doc_respondent, verdict, arbi_number FROM tbl_document WHERE doc_id = ?";
            if ($stmt = $conn->prepare($sql)) {
                $stmt->bind_param("i", $doc_id);
                $stmt->execute();
                $result = $stmt->get_result();
                if ($result->num_rows > 0) {
                    // Fetch document details
                    $doc = $result->fetch_assoc();
                    
                    // Insert into tbl_archived, including the arbi_number
                    $sqlInsert = "INSERT INTO tbl_archived (doc_id, doc_name, doc_complainant, doc_respondent, verdict, arbi_number) 
                                  VALUES (?, ?, ?, ?, ?, ?)";
                    if ($stmtInsert = $conn->prepare($sqlInsert)) {
                        $stmtInsert->bind_param("isssss", 
                            $doc['doc_id'], 
                            $doc['doc_name'], 
                            $doc['doc_complainant'], 
                            $doc['doc_respondent'], 
                            $doc['verdict'],
                            $doc['arbi_number']); // Add the arbiter number here
                        if ($stmtInsert->execute()) {
                            // Update the status of the document in tbl_document to 'Archived'
                            $sqlUpdate = "UPDATE tbl_document SET status = 'Archived' WHERE doc_id = ?";
                            if ($stmtUpdate = $conn->prepare($sqlUpdate)) {
                                $stmtUpdate->bind_param("i", $doc_id);
                                if ($stmtUpdate->execute()) {
                                    // Commit the transaction
                                    $conn->commit();
                                    echo json_encode(["status" => "success", "message" => "Document successfully archived"]);
                                } else {
                                    // Rollback the transaction if the update fails
                                    $conn->rollback();
                                    echo json_encode(["status" => "error", "message" => "Failed to update document status"]);
                                }
                            } else {
                                $conn->rollback();
                                echo json_encode(["status" => "error", "message" => "Failed to prepare status update query"]);
                            }
                        } else {
                            $conn->rollback();
                            echo json_encode(["status" => "error", "message" => "Failed to insert into tbl_archived"]);
                        }
                    } else {
                        $conn->rollback();
                        echo json_encode(["status" => "error", "message" => "Failed to prepare insert query"]);
                    }
                } else {
                    echo json_encode(["status" => "error", "message" => "Document not found"]);
                }
                $stmt->close();
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to prepare fetch query"]);
            }
        } catch (Exception $e) {
            // Rollback transaction on error
            $conn->rollback();
            echo json_encode(["status" => "error", "message" => "Error: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing document ID"]);
    }
}

$conn->close();
?>
