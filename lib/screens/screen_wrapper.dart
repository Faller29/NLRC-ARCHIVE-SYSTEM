import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/screens/archive_page.dart';
import 'package:nlrc_archive/screens/home_page.dart';
import 'package:nlrc_archive/screens/login_page.dart';
import 'package:nlrc_archive/screens/settings.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';

List<Map<String, String>> arbiter = [];
String? adminType;
bool isFetching = false;

class ScreenWrapper extends StatefulWidget {
  final adminType;
  final name;
  final room;
  ScreenWrapper({Key? key, this.adminType, this.name, this.room})
      : super(key: key);

  @override
  _ScreenWrapperState createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];
  final List<Widget> _pages = [HomePage(), SettingsPage()];

  Future<void> fetchArbiters() async {
    List<Map<String, String>> arbiters = await getArbiters();
    setState(() {
      arbiter = arbiters;
      adminType = widget.adminType;
    });
  }

  @override
  void initState() {
    fetchArbiters();
    fetch();
    super.initState();
  }

  fetch() async {
    setState(() {
      isFetching = true;
    });
    print('fetching');
    documents = await fetchDocuments(query);
    sackCreatedList = await fetchCreatedSack();
    sackPendingList = await fetchPendingSack();
    setState(() {
      isFetching = false;
    });
    print('fetched');
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
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
}
