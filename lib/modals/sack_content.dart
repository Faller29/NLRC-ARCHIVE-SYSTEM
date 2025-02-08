import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/modals/add_document.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SackContent extends StatefulWidget {
  final String sackId;
  final String sackName;
  final String? pending;

  const SackContent(
      {Key? key, required this.sackId, required this.sackName, this.pending})
      : super(key: key);

  @override
  State<SackContent> createState() => _SackContentState();
}

class _SackContentState extends State<SackContent> {
  late Future<List<Map<String, String>>> futureDocuments;

  @override
  void initState() {
    super.initState();
    futureDocuments = fetchDocuments(widget.sackId);
  }

  Future<List<Map<String, String>>> fetchDocuments(String sackId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://$serverIP/nlrc_archive_api/retrieve_document.php?sack_id=$sackId'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          final data = List<Map<String, dynamic>>.from(responseData['data']);
          if (data.isEmpty) return [];
          return data.map((doc) {
            return doc.map((key, value) => MapEntry(key, value.toString()));
          }).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteDocument(var docId) async {
    print(docId);
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP/nlrc_archive_api/delete_document.php'),
        body: {'doc_id': docId},
      );
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarSuccess('Document deleted successfully', context),
        );
        setState(() {
          futureDocuments = fetchDocuments(widget.sackId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed(
              'Failed to delete document: ${data['message']}', context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error: $e', context),
      );
    }
  }

  void showDeleteConfirmation(var docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Document'),
          content: Text('Are you sure you want to delete this document?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                deleteDocument(docId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${widget.sackName}',
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.5,
        child: FutureBuilder<List<Map<String, String>>>(
          future: futureDocuments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final documents = snapshot.data!;
              if (documents.isEmpty) {
                return Center(
                    child: Text('No documents associated with this sack.'));
              }
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];

                  return Card(
                    color: Colors.green[100],
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      title: Text(
                        doc['doc_number'] ?? 'No Document Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  doc['doc_complainant'] ?? 'No complaint',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'VERSUS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  doc['doc_respondent'] ?? 'No respondent',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Verdict: ${doc['verdict']!.isEmpty ? 'No Decision' : doc['verdict']}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Volume: ${doc['doc_volume']!.isEmpty ? 'No volume' : doc['doc_volume']}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: widget.pending != 'pending'
                          ? SizedBox(
                              width:
                                  80, // Prevents overflowing by limiting width
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddEditDocument(
                                          sackId: widget.sackId,
                                          onDocumentUpdated: () {
                                            setState(() {
                                              futureDocuments =
                                                  fetchDocuments(widget.sackId);
                                            });
                                          },
                                          document: doc,
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () => showDeleteConfirmation(
                                        doc['doc_id'] ?? ''),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  );
                },
              );
            } else {
              return Center(
                  child: Text('No documents associated with this sack.'));
            }
          },
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        if (widget.pending != 'pending')
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AddEditDocument(
                  sackId: widget.sackId,
                  onDocumentUpdated: () {
                    setState(() {
                      futureDocuments = fetchDocuments(widget.sackId);
                    });
                  },
                );
              },
            ),
            child: Text('Add Document'),
          ),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
