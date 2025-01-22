import 'package:flutter/material.dart';
import 'package:nlrc_archive/modals/add_document.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SackContent extends StatefulWidget {
  final String sackId;

  const SackContent({Key? key, required this.sackId}) : super(key: key);

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

  // API Endpoint for fetching document
  Future<List<Map<String, String>>> fetchDocuments(String sackId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost/nlrc_archive_api/retrieve_document.php?sack_id=$sackId'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          final data = List<Map<String, dynamic>>.from(responseData['data']);

          if (data.isEmpty) {
            return [];
          }

          return data.map((doc) {
            return doc.map((key, value) => MapEntry(key, value.toString()));
          }).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sack ID: ${widget.sackId}'),
      content: SizedBox(
        // Ensure the content has bounded dimensions
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.3,
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
                    child: Text('No data associated with this sack.'));
              }
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  return ListTile(
                    title: Text(doc['doc_title'] ?? 'No Title'),
                    subtitle: Text(
                      'Document Number: ${doc['doc_number'] ?? 'No Number'}',
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data associated with this sack.'));
            }
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AddDocument(
                sackId: widget.sackId,
                onDocumentAdded: () {
                  setState(() {
                    futureDocuments =
                        fetchDocuments(widget.sackId); // Refresh the future
                  });
                },
              );
            },
          ),
          child: Text('Add'),
        ),
      ],
    );
  }
}
