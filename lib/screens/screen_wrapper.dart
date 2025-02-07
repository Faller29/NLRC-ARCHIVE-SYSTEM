import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/screens/home_page.dart';
import 'package:nlrc_archive/screens/login_page.dart';
import 'package:nlrc_archive/screens/settings.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';
import 'package:nlrc_archive/data/themeData.dart';

List<Map<String, dynamic>> arbiter = [];
String? adminType;
bool isFetching = false;
var user;
var accountId;

class ScreenWrapper extends StatefulWidget {
  final adminType;
  final name;
  final room;
  final accountId;

  ScreenWrapper(
      {Key? key, this.adminType, this.name, this.room, this.accountId})
      : super(key: key);

  @override
  _ScreenWrapperState createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> get _menuItems {
    List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home, 'label': 'Home'},
    ];
    if (user == null) {
      menuItems.add({'icon': Icons.settings, 'label': 'Settings'});
    }
    return menuItems;
  }

  final List<Widget> _pages = [HomePage(), SettingsPage()];

  late Timer _timer;

  @override
  void initState() {
    user = widget.name;
    accountId = widget.accountId;

    fetchArbitersList();
    fetchAccounts();
    fetch();
    _startPolling();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  fetch() async {
    setState(() {
      isFetching = true;
    });
    requestedDocument = await fetchRequestedDocuments();
    documents = await fetchDocuments(query, user);
    sackCreatedList = await fetchCreatedSack();
    sackPendingList = await fetchPendingSack();

    setState(() {
      isFetching = false;
    });
  }

  _startPolling() async {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!isFetching) {
        fetchRequestedDocuments().then((data) {
          if (!listsAreEqual(requestedDocument, data)) {
            if (mounted) {
              setState(() {
                requestedDocument = data;
              });
            }
          }
        });
      }
    });
  }

  bool listsAreEqual(var list1, var list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (!mapEquals(list1[i], list2[i])) {
        return false;
      }
    }

    return true;
  }

  bool mapEquals(var map1, var map2) {
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
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 300,
                color: Colors.blueGrey[800],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 10, left: 10, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.name == null ? 'Admin' : widget.name}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${widget.room == null ? 'Archive Room' : "Room ${widget.room}"}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'Navigation',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _menuItems.length,
                        itemBuilder: (context, index) {
                          final isSelected = _selectedIndex == index;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueGrey[700]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    _menuItems[index]['icon'],
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[400],
                                  ),
                                  title: Text(
                                    _menuItems[index]['label'],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Card(
                          color: Colors.white54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Requests',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(color: Colors.black),
                                Expanded(
                                  child:
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                    future: fetchRequestedDocuments(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error loading documents'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text('No requests found'));
                                      }

                                      return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          var doc = snapshot.data![index];

                                          return Card(
                                            color: const Color.fromARGB(
                                                211, 255, 255, 255),
                                            child: ListTile(
                                              title: Text(doc['doc_number'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onTap: () => showDocumentDialog(
                                                  doc, context),
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {
                          documents.clear();
                          sackPendingList.clear();
                          sackCreatedList.clear();
                          requestedDocument.clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => IndexPage()),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _pages[_selectedIndex],
                ),
              ),
            ],
          ),
          if (isFetching)
            Positioned.fill(
              child: Container(
                color: Colors.blue.withValues(alpha: 0.5),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Fetching Data, Please wait.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

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
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                              doc['arbiter_number'] ?? 'N/A',
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
                            Icon(Icons.gavel,
                                size: 16, color: Colors.grey[600]),
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
                                      doc['doc_id'], "Retrieved")
                                  .then((_) {
                                setState(() {
                                  //ref
                                });
                              });

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
}
