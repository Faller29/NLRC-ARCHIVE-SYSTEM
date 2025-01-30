import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:intl/intl.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart'; // for formatting timestamp
import 'package:nlrc_archive/data/themeData.dart';

void showDocumentDialog(Map<String, dynamic> doc, context) {
  String formattedTimestamp = '';
  if (doc['timestamp'] != null && doc['timestamp'].isNotEmpty) {
    DateTime timestamp = DateTime.parse(doc['timestamp']);
    formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: StatefulBuilder(builder: (context, snapshot) {
          return Card(
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tooltip(
                            message: "Complainant: ${doc['doc_complainant']}",
                            child: SizedBox(
                              width: 400,
                              child: Text(
                                doc['doc_complainant'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Text(
                            "vs",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 0.5,
                            ),
                          ),
                          Tooltip(
                            message: "Respondent: ${doc['doc_respondent']}",
                            child: SizedBox(
                              width: 400,
                              child: Text(
                                doc['doc_respondent'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'Requested',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Case #: ${doc['doc_number'].toUpperCase()}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Volume: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                              "${doc['volume'].toString().isEmpty ? "No volume" : doc['volume']}"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.storage,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6.0),
                          Text(
                            'Arbiter: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            doc['arbiter_number'] ??
                                'N/A', // Display arbiter name
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 6.0),
                          Text(
                            'Sack: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            doc['sack_name'] ?? 'N/A',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.gavel, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6.0),
                          Text(
                            'Verdict: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                              "${doc['verdict'].toString().isEmpty ? "No verdict" : doc['verdict']}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${(doc['version'].toString()).capitalize()} version",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Requested on: $formattedTimestamp", // Display timestamp
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Request by: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        doc['arbi_name'].toString().capitalize() ?? 'N/A',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (user == null) Divider(),
                  if (user == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Approve')
                            ],
                          ),
                          onPressed: () async {
                            await updateDocumentStatus(
                                doc['doc_id'], "Retrieved");

                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Reject'),
                            ],
                          ),
                          onPressed: () {
                            updateDocumentStatus(doc['doc_id'], "Stored");
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}
