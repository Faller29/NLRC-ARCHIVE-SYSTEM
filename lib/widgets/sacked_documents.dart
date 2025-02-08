import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nlrc_archive/data/themeData.dart';
import 'dart:convert';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';

class SackedDocumentsDialog extends StatefulWidget {
  final String? user;

  SackedDocumentsDialog({Key? key, this.user}) : super(key: key);

  @override
  _SackedDocumentsDialogState createState() => _SackedDocumentsDialogState();
}

class _SackedDocumentsDialogState extends State<SackedDocumentsDialog> {
  TextEditingController searchController = TextEditingController();
  Map<int, bool> expandedSacks = {}; // Track expanded sacks
  String searchQuery = "";
  String? selectedArbiterId;

  Future<List<Map<String, dynamic>>> fetchSackedDocuments() async {
    var url = "http://$serverIP/nlrc_archive_api/retrieve_data.php";
    final uri = Uri.parse(url).replace(queryParameters: {
      'Query': searchQuery,
      'User': widget.user ?? '',
      'arbi': selectedArbiterId ?? '',
    });

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Map<int, Map<String, dynamic>> groupedSacks = {};

        for (var item in data) {
          int sackId = int.tryParse(item['sack_id'].toString()) ?? 0;
          if (!groupedSacks.containsKey(sackId)) {
            groupedSacks[sackId] = {
              'sack_id': sackId,
              'sack_name': item['sack_name'] ?? 'Unknown Sack',
              'arbiter_name': item['arbiter_number'] ?? 'Unknown Arbiter',
              'documents': [],
            };
          }
          groupedSacks[sackId]!['documents'].add({
            'doc_id': int.tryParse(item['doc_id'].toString()) ?? 0,
            'doc_complainant': item['doc_complainant'] ?? 'No Complainant',
            'doc_respondent': item['doc_respondent'] ?? 'No Respondent',
            'doc_number': item['doc_number'] ?? 'No Document Number',
            'status': item['doc_status'] ?? 'Unknown',
            'verdict': item['verdict'] ?? 'No Verdict',
            'version': item['version'] ?? 'Unknown Version',
            'doc_volume': item['volume'] ?? 'Unknown Volume',
            'arbi_name': item['arbiter_number'] ?? 'No Arbiter',
          });
        }
        return groupedSacks.values.toList();
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: 300, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sacked Documents',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Sack, Document, Complainant, or Respondent',
                prefixIcon: Icon(Icons.search),
                suffixIcon: SizedBox(
                  width: 200,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: getArbiters(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final arbiters = snapshot.data ?? [];

                      if (arbiters.isEmpty) {
                        return Text('No arbiters available');
                      }

                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                          ),
                        ),
                        isExpanded: true,
                        value: widget.user ?? selectedArbiterId,
                        hint: Text('Select Arbiter'),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              'All',
                            ),
                          ),
                          ...((widget.user == null
                                  ? arbiters
                                      .map((arbiter) =>
                                          arbiter['name'].toString())
                                      .toList()
                                  : [widget.user!])
                              .map((choice) {
                            return DropdownMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList()),
                        ],
                        onChanged: widget.user == null
                            ? (value) {
                                setState(() {
                                  selectedArbiterId = value;
                                  print("Selected Arbiter: $selectedArbiterId");
                                });
                              }
                            : null,
                        disabledHint:
                            widget.user != null ? Text(widget.user!) : null,
                      );
                    },
                  ),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchSackedDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No sacks found'));
                  }
                  final sacks = snapshot.data!;
                  sacks
                      .sort((a, b) => a['sack_name'].compareTo(b['sack_name']));

                  return ListView.builder(
                    itemCount: sacks.length,
                    itemBuilder: (context, index) {
                      final sack = sacks[index];
                      int sackId = sack['sack_id'];

                      return Card(
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${sack['sack_name'].toString().toUpperCase()} - ${sack['arbiter_name'].toString().toUpperCase()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  if (widget.user == null)
                                    Text(
                                        "Total Documents: ${sack['documents'].length}"),
                                ],
                              ),
                              if (widget.user != null)
                                Text(
                                    "Total Documents: ${sack['documents'].length}"),
                              if (widget.user == null)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
                                  onPressed: () {
                                    // Show AlertDialog when button is pressed
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Action'),
                                          content: Text(
                                              'Are you sure you want to dispose all the documents in this sack?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor:
                                                      Colors.white),
                                              onPressed: () {
                                                disposeSack(sackId)
                                                    .then((success) {
                                                  if (success) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      snackBarSuccess(
                                                          'Sack disposed successfully!',
                                                          context),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      snackBarFailed(
                                                          'Failed to dispose of the sack.',
                                                          context),
                                                    );
                                                  }

                                                  setState(() {
                                                    //ref
                                                  });
                                                });

                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Dispose'),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          initiallyExpanded: expandedSacks[sackId] ?? false,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              expandedSacks[sackId] = expanded;
                            });
                          },
                          children: [
                            ...sack['documents'].map<Widget>((doc) {
                              String docStatus = doc['status'];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Case #: ${doc['doc_number']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 6.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: docStatus == 'Stored'
                                                  ? Colors.green[100]
                                                  : docStatus == 'Requested'
                                                      ? Colors.blue[100]
                                                      : Colors.red[100],
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Text(
                                              docStatus,
                                              style: TextStyle(
                                                color: docStatus == 'Stored'
                                                    ? Colors.green[800]
                                                    : docStatus == 'Requested'
                                                        ? Colors.blue[800]
                                                        : Colors.red[800],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "${doc['doc_complainant']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "Versus",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12,
                                                  height: 0.8),
                                            ),
                                            Text(
                                              "${doc['doc_respondent']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.storage,
                                              size: 16,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 6.0),
                                          Text(
                                            'Arbiter: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            "${doc['arbi_name']}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.gavel,
                                              size: 16,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 6.0),
                                          Text(
                                            'Decision: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            "${doc['verdict'].toString().isEmpty ? 'No Decision' : doc['verdict']}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.book,
                                                color: Colors.grey[600],
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                'Volume: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(
                                                  "${doc['doc_volume'].toString().isEmpty ? 'No volume' : doc['doc_volume'].toString()}"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              /* Icon(Icons.storage,
                                                  size: 16,
                                                  color: Colors.grey[600]),
                                              const SizedBox(width: 6.0), */
                                              Text(
                                                'Version: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(
                                                "${doc['version'].toString().isEmpty ? 'No' : doc['version'].toString().capitalize()} Version",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
