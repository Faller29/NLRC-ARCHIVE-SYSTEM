import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';

class DocumentDialog extends StatefulWidget {
  DocumentDialog({Key? key}) : super(key: key);

  @override
  _DocumentDialogState createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<DocumentDialog> {
  int currentDisposePage = 0;
  final int disposePageSize = 5;
  TextEditingController disposeSearch = TextEditingController();

  @override
  void dispose() {
    disposeQuery = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 - 100,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2 - 100,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Find Archived Document',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 2 - 100,
                child: TextField(
                  controller: disposeSearch,
                  onChanged: (value) {
                    setState(() {
                      disposeQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Case number, Complainant, or Respondent',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: InkWell(
                      child: ClipRRect(
                          child: Icon(
                        Icons.cancel_sharp,
                        size: 26,
                      )),
                      onTap: () {
                        disposeSearch.clear();
                        setState(() {
                          disposeQuery = '';
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: 600,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchDisposedDocuments(disposeQuery, user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No documents found.'));
                    }

                    disposeDocuments = snapshot.data!;
                    disposeDocuments.sort((a, b) {
                      return (a['doc_complainant'] ?? '')
                          .compareTo(b['doc_complainant'] ?? '');
                    });

                    // Pagination logic
                    int totalDisposePages =
                        (disposeDocuments.length / disposePageSize).ceil();
                    int startIndex = currentDisposePage * disposePageSize;
                    int endIndex = startIndex + disposePageSize;
                    List<Map<String, dynamic>> visibleDisposeDocuments =
                        disposeDocuments.sublist(
                            startIndex,
                            endIndex > disposeDocuments.length
                                ? disposeDocuments.length
                                : endIndex);

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: visibleDisposeDocuments.length,
                            itemBuilder: (context, index) {
                              final doc = visibleDisposeDocuments[index];

                              final sackName =
                                  doc['sack_name'] ?? 'No Sack Name';
                              final doc_complainant =
                                  doc['doc_complainant'] ?? 'No complainant';
                              final doc_respondent =
                                  doc['doc_respondent'] ?? 'No respondent';
                              final docStatus = doc['status'] ?? 'Unknown';
                              final verdict =
                                  "${doc['verdict']!.isEmpty ? 'No Decision' : doc['verdict']}";
                              final arbiName = doc['arbi_name'] ?? 'No arbiter';
                              final docId = doc['doc_id'] ?? 'No document Id';

                              String docName =
                                  doc['doc_number'] ?? 'No document name';
                              String docVolume =
                                  "${doc['doc_volume']!.isEmpty ? 'No volume' : doc['doc_volume']}";
                              String version = "${doc['version']}" ?? 'No';

                              return Card(
                                color: Colors.grey[300],
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                      top: 5.0,
                                      left: 16.0,
                                      right: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Case #: ${docName.toUpperCase()}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          /* Text(
                                            "${arbiName.toUpperCase()} - ${sackName.toUpperCase()}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 25, 94, 8),
                                            ),
                                          ), */
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Tooltip(
                                                message: doc_complainant,
                                                child: SizedBox(
                                                  width: 400,
                                                  child: Text(
                                                    doc_complainant,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "vs.",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  height: 0.8,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Tooltip(
                                                message: doc_respondent,
                                                child: SizedBox(
                                                  width: 400,
                                                  child: Text(
                                                    doc_respondent,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18.0),
                                      /* Row(
                                        children: [
                                          Icon(
                                            Icons.book,
                                            color: Colors.grey[600],
                                            size: 16,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'Volume: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text('${docVolume}'),
                                        ],
                                      ), */
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                                arbiName,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.book,
                                                color: Colors.grey[600],
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Volume: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text('${docVolume}'),
                                            ],
                                          ),
                                          /* Row(
                                            children: [
                                              const SizedBox(width: 6.0),
                                              Text(
                                                'Storage: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(
                                                sackName,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ), */
                                        ],
                                      ),
                                      const SizedBox(height: 6.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                              Text(verdict),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${version.capitalize()} version",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: currentDisposePage > 0
                                  ? () {
                                      setState(() {
                                        currentDisposePage--;
                                      });
                                    }
                                  : null,
                              icon: Icon(Icons.arrow_left),
                            ),
                            SizedBox(width: 16),
                            Text(
                                "Page ${currentDisposePage + 1} of $totalDisposePages"),
                            SizedBox(width: 16),
                            IconButton(
                                onPressed:
                                    currentDisposePage < totalDisposePages - 1
                                        ? () {
                                            setState(() {
                                              currentDisposePage++;
                                            });
                                          }
                                        : null,
                                icon: Icon(Icons.arrow_right))
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
