import 'dart:async';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";

  String? _selectedArbiter;
  final TextEditingController _sackId = TextEditingController();
  TextEditingController rejectReason = TextEditingController();

  List<dynamic> _arbiterChoices = [];
  late Timer _timer;
  //List<Map<String, dynamic>> documents = [];
  @override
  void initState() {
    fetchArbiters();
    _startPolling();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchArbiters() async {
    final url = "http://localhost/nlrc_archive_api/get_arbi_choices.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          if (data.isNotEmpty) {
            _arbiterChoices =
                data.map((arbiter) => arbiter['arbi_name']).toList();
          } else {
            print('No arbiters found');
          }
        });
      } else {
        throw Exception('Failed to load arbiters');
      }
    } catch (error) {
      print("Error fetching arbiters: $error");
    }
  }

  Future<void> addSack() async {
    if (_sackId.text.isEmpty ||
        _selectedArbiter == null ||
        _selectedArbiter!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please enter a sack name and select an arbiter number')),
      );
      return;
    }

    var url = "http://localhost/nlrc_archive_api/add_sack.php";
    var response = await http.post(Uri.parse(url), body: {
      "sack_name": _sackId.text,
      "arbiter_number": _selectedArbiter,
      "sack_status": 'Creating',
    });

    var data = jsonDecode(response.body);

    if (data['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added Sack Successfully")),
      );
      setState(() {
        sackCreatedList.add({
          "sack_id": data['sack_id'].toString(),
          "sack_name": _sackId.text,
          "arbiter_number": _selectedArbiter,
        });
      });
      _sackId.clear();
      _selectedArbiter = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to Add Sack')),
      );
    }
    Navigator.pop(context);
  }

  Future<void> deleteSack(String sackId, int index) async {
    var url = "http://localhost/nlrc_archive_api/delete_sack.php";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          "sack_id": sackId,
        },
      );

      var data = jsonDecode(response.body);

      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted Successfully')),
        );
        setState(() {
          sackCreatedList.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Delete')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    Navigator.pop(context);
  }

  Future<void> updateSackStatus(String sackId) async {
    print(sackId);
    var url = "http://localhost/nlrc_archive_api/update_sack_status.php";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'sack_id': sackId,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update sack status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> rejectPending(sackId) async {
    var url = "http://localhost/nlrc_archive_api/reject_sack.php";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'sack_id': sackId,
          'reject_message': rejectReason.text,
        },
      );
      print(rejectReason.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject sack status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  _startPolling() async {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (!isFetching) {
        fetchDocuments(query).then((data) {
          if (!_listsAreEqual(documents, data)) {
            setState(() {
              documents = data;
            });
          }
        });

        fetchCreatedSack().then((data) {
          if (!_listsAreEqual(sackCreatedList, data)) {
            setState(() {
              sackCreatedList = data;
            });
          }
        });

        fetchPendingSack().then((data) {
          if (!_listsAreEqual(sackPendingList, data)) {
            setState(() {
              sackPendingList = data;
            });
          }
        });
      }
    });
  }

  bool _listsAreEqual(var list1, var list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (!_mapEquals(list1[i], list2[i])) {
        return false;
      }
    }

    return true;
  }

  bool _mapEquals(var map1, var map2) {
    if (map1.keys.length != map2.keys.length) {
      return false;
    }

    for (var key in map1.keys) {
      if (map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Card(
                  color: const Color.fromARGB(255, 60, 45, 194),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width / 2 - 90,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${today.toString()}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const Text(
                                "ARCHIVE",
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 0.8,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "${nlrc.toUpperCase()}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/images/NLRC-WHITE.png',
                            fit: BoxFit.scaleDown,
                            width: 150,
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Find Document',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2 - 100,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    query = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      'Search Case number, Complainant, or Respondent',
                                  prefixIcon: Icon(Icons.search),
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
                                future: fetchDocuments(query),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                        child: Text('No documents found.'));
                                  }

                                  //final documents = snapshot.data!;
                                  documents = snapshot.data!;

                                  documents.sort((a, b) {
                                    return (a['doc_complainant'] ?? '')
                                        .compareTo(b['doc_complainant'] ?? '');
                                  });
                                  return ListView.builder(
                                    itemCount: documents.length,
                                    itemBuilder: (context, index) {
                                      final doc = documents[index];

                                      final sackName =
                                          doc['sack_name'] ?? 'No Sack Name';
                                      final doc_complainant =
                                          doc['doc_complainant'] ??
                                              'No complainant';
                                      final doc_respondent =
                                          doc['doc_respondent'] ??
                                              'No respondent';
                                      final docStatus =
                                          doc['status'] ?? 'Unknown';
                                      final verdict =
                                          "${doc['verdict']!.isEmpty ? 'No Verdict' : doc['verdict']}";
                                      final arbiName =
                                          doc['arbi_name'] ?? 'No arbiter';
                                      final docId =
                                          doc['doc_id'] ?? 'No document Id';

                                      String docName =
                                          doc['doc_name'] ?? 'No document name';
                                      String docVolume =
                                          "${doc['volume']!.isEmpty ? 'No volume' : doc['volume']}";
                                      String version =
                                          "${doc['version']}" ?? 'No';

                                      return Card(
                                        color: Colors.grey[300],
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Title Row
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "$doc_complainant",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "vs",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            height: 0.5),
                                                      ),
                                                      Text(
                                                        "$doc_respondent",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 6.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: docStatus ==
                                                              'Stored'
                                                          ? Colors.green[100]
                                                          : Colors.red[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Text(
                                                      docStatus,
                                                      style: TextStyle(
                                                        color: docStatus ==
                                                                'Stored'
                                                            ? Colors.green[800]
                                                            : Colors.red[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Case #: ${docName.toUpperCase()}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Volume: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        '${docVolume}',
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.storage,
                                                          size: 16,
                                                          color:
                                                              Colors.grey[600]),
                                                      const SizedBox(
                                                          width: 6.0),
                                                      Text(
                                                        'Arbiter: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        arbiName,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      /* Icon(Icons.storage,
                                                          size: 16,
                                                          color:
                                                              Colors.grey[600]), */
                                                      const SizedBox(
                                                          width: 6.0),
                                                      Text(
                                                        'Storage: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        sackName,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.gavel,
                                                          size: 16,
                                                          color:
                                                              Colors.grey[600]),
                                                      const SizedBox(
                                                          width: 6.0),
                                                      Text(
                                                        'Verdict: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        verdict,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      /* Text(
                                                        'Version: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ), */
                                                      Text(
                                                        "${version.capitalize()} version",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              '$docName',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    'Request archive for retrieval'),
                                                              ],
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  bool success =
                                                                      await requestRetrieval(
                                                                          docId);

                                                                  if (success) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text('Retrieval request sent!'),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text('Failed to request retrieval'),
                                                                      ),
                                                                    );
                                                                  }

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'Confirm'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text('Request'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Archive Document',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  Expanded(
                                    child: Container(
                                      width:
                                          MediaQuery.sizeOf(context).width / 2 -
                                              100,
                                      child: FutureBuilder<List<dynamic>>(
                                          future: fetchCreatedSack(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                      'There is no records found'));
                                            }
                                            sackCreatedList = snapshot.data!;
                                            return sackCreatedList.isEmpty
                                                ? Center(
                                                    child: Text(
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: Colors.grey),
                                                        'There is no records found'))
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        sackCreatedList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final sack =
                                                          sackCreatedList[
                                                              index];

                                                      bool isRejected =
                                                          sack['status'] ==
                                                              'Reject';

                                                      return Column(
                                                        children: [
                                                          Container(
                                                            color: isRejected
                                                                ? Colors.red
                                                                : Colors
                                                                    .transparent,
                                                            child: ListTile(
                                                              title: Text(
                                                                sack['sack_name'] ??
                                                                    'No Sack Name',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: isRejected
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    sack['arbiter_number'] ??
                                                                        'No Arbiter Name',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: isRejected
                                                                          ? Colors
                                                                              .white70
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  ),
                                                                  if (isRejected)
                                                                    Text(
                                                                      "Rejected: ${sack['admin_message'] ?? 'No reason provided'}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                        color: Colors
                                                                            .white70,
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                              trailing: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: isRejected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .red,
                                                                    ),
                                                                    onPressed: () =>
                                                                        showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          ((context) {
                                                                        return AlertDialog(
                                                                          contentPadding: EdgeInsets.symmetric(
                                                                              vertical: 40,
                                                                              horizontal: 30),
                                                                          title:
                                                                              Text('Delete ${sack['sack_name']}'),
                                                                          content:
                                                                              Text('Are you sure you want to delete ${sack['sack_name']}?'),
                                                                          actions: [
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.redAccent,
                                                                                foregroundColor: Colors.white,
                                                                              ),
                                                                              onPressed: () => Navigator.pop(context),
                                                                              child: Text('Cancel'),
                                                                            ),
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.green,
                                                                                foregroundColor: Colors.white,
                                                                              ),
                                                                              onPressed: () => deleteSack(
                                                                                sack['sack_id'].toString(),
                                                                                index,
                                                                              ),
                                                                              child: Text('Confirm'),
                                                                            ),
                                                                          ],
                                                                          actionsAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                        );
                                                                      }),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .send,
                                                                      color: isRejected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .green,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      final sackId =
                                                                          sack['sack_id']
                                                                              .toString();
                                                                      final response =
                                                                          await sendForApproval(
                                                                              sackId);

                                                                      if (response[
                                                                              'status'] ==
                                                                          'success') {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                              content: Text('Sack sent for approval')),
                                                                        );
                                                                        setState(
                                                                            () {
                                                                          sack['status'] =
                                                                              'pending';
                                                                        });
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                              content: Text('${response['message']}')),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () =>
                                                                  showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return SackContent(
                                                                    sackId: sack[
                                                                        'sack_id'],
                                                                    sackName: sack[
                                                                        'sack_name'],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(),
                                                        ],
                                                      );
                                                    },
                                                  );
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                top: 30,
                                right: 0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Create Sack'),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFieldBoxWidget(
                                                controller: _sackId,
                                                labelText: 'Enter Sack ID'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: _selectedArbiter == null
                                                  ? null
                                                  : _selectedArbiter,
                                              decoration: InputDecoration(
                                                labelText: 'Arbiter',
                                                border: OutlineInputBorder(),
                                              ),
                                              items:
                                                  _arbiterChoices.map((choice) {
                                                return DropdownMenuItem<String>(
                                                  value: choice,
                                                  child: Text(choice),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedArbiter =
                                                      value ?? '';
                                                  print(_selectedArbiter);
                                                });
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select an arbiter';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                foregroundColor: Colors.white),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Close'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white),
                                            onPressed: addSack,
                                            child: Text('Add'),
                                          ),
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.spaceAround,
                                      );
                                    }),
                                  ),
                                  child: Text(
                                    '+ Sack',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: Card(
                        color: const Color.fromARGB(255, 25, 17, 134)
                            .withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Approval',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.white),
                                    bottom: BorderSide(color: Colors.white),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Sack ID',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    if (adminType == null)
                                      Expanded(
                                        child: Text(
                                          'Action',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: FutureBuilder<List<dynamic>>(
                                    future: fetchPendingSack(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Center(
                                          child: Text(
                                            'No pending sacks found.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ));
                                      }
                                      sackPendingList = snapshot.data!;
                                      return ListView.builder(
                                        itemCount: sackPendingList.length,
                                        itemBuilder: (context, index) {
                                          final sack = sackPendingList[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    sack['sack_name'] ?? 'N/A',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                if (adminType == null)
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                          onPressed: () async {
                                                            final sackId =
                                                                sack['sack_id'];
                                                            if (sackId !=
                                                                null) {
                                                              await updateSackStatus(
                                                                      sackId)
                                                                  .then(
                                                                      (_) async {
                                                                setState(() {
                                                                  //ref
                                                                });
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            final sackId =
                                                                sack['sack_id'];
                                                            if (sackId !=
                                                                null) {
                                                              await rejectSack(
                                                                  sackId);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> rejectSack(String sackId) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reason for Rejection'),
          content: TextField(
            controller: rejectReason,
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter reason for rejection"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                rejectReason.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await rejectPending(sackId).then((_) {
                  setState(() {
                    //ref
                  });
                });
                rejectReason.clear();
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
