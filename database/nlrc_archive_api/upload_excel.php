<?php
header("Content-Type: application/json");
include('setConnection/db_connection.php'); 

require 'vendor/autoload.php';
use PhpOffice\PhpSpreadsheet\IOFactory;
$con = dbconnection(); 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (isset($_FILES['file']) && isset($_POST['arbiter_number']) && isset($_POST['account_id'])) {
        $arbiterNumber = $_POST['arbiter_number'];
        $accountId = (int) $_POST['account_id'];
        $doc_version = $_POST['doc_version'] ?? null;
        $sack_status = 'Pending';

        // Handle file upload and read Excel file
        $fileTmpPath = $_FILES['file']['tmp_name'];
        $spreadsheet = IOFactory::load($fileTmpPath);
        $sheetNames = $spreadsheet->getSheetNames();

        foreach ($sheetNames as $sheetName) {
            $sheet = $spreadsheet->getSheetByName($sheetName);
            $rows = $sheet->toArray();

            if (!empty($rows)) {
                // Insert into tbl_sack with acc_id as accountId
                $stmt = $con->prepare("INSERT INTO tbl_sack (arbiter_number, sack_name, status, acc_id) VALUES (?, ?, ?, ?)");
                $stmt->bind_param("sssi", $arbiterNumber, $sheetName, $sack_status, $accountId); 
                $stmt->execute();
                $sackId = $stmt->insert_id;
                $stmt->close();

                // Insert data into tbl_document
                $stmtDoc = $con->prepare(
                    "INSERT INTO tbl_document (sack_id, doc_number, doc_complainant, doc_respondent, volume, verdict, status, version) 
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                );
                
                foreach ($rows as $index => $row) {
                    if ($index === 0) continue; // Skip header row if applicable
                    $docNumber = $row[0] ?? '';
                    $docComplainant = $row[1] ?? '';
                    $docRespondent = $row[2] ?? '';
                    $volume = $row[3] ?? '';
                    $verdict = $row[4] ?? '';
                    $doc_status = 'Stored';
                
                    if (!empty($docNumber)) {
                        $stmtDoc->bind_param("isssssss", $sackId, $docNumber, $docComplainant, $docRespondent, $volume, $verdict, $doc_status, $doc_version);
                        $stmtDoc->execute();
                    }
                }
                

                $stmtDoc->close();
            }
        }

        echo json_encode(["status" => "success", "message" => "Excel data uploaded successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid request"]);
    }
}
?>