import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArchivePage extends StatefulWidget {
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final TextEditingController _sackId = TextEditingController();
  List<dynamic> sackList = [];

  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";

  String? _selectedArbiter;

  final List<String> _arbiterChoices = ['Arbiter 1', 'Arbiter 2', 'Arbiter 3'];

  @override
  void initState() {
    fetch_created_sack();
    super.initState();
  }

  Future<void> fetch_created_sack() async {
    var url = "http://$serverIP/nlrc_archive_api/retrieve_sack.php";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          sackList = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> addSack() async {
    if (_sackId.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a sack name')),
      );
      return;
    }

    var url = "http://$serverIP/nlrc_archive_api/add_sack.php";
    var response = await http.post(Uri.parse(url), body: {
      "sack_name": _sackId.text,
    });

    var data = jsonDecode(response.body);

    if (data['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added Sack Successful")),
      );
      setState(() {
        sackList.add({
          "sack_id": data['sack_id'],
          "sack_name": _sackId.text,
        });
      });
      _sackId.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['Failed to Add Sack'])),
      );
    }
  }

  Future<void> deleteSack(String sackId, int index) async {
    var url = "http://$serverIP/nlrc_archive_api/delete_sack.php";
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
          sackList.removeAt(index);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              color: const Color.fromARGB(255, 60, 45, 194),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ),
                          const Text(
                            "ARCHIVE",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 0.8,
                            ),
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
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Arbiters',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
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
                                        const SizedBox(height: 20),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                        .width /
                                                    2 -
                                                100,
                                            child: sackList.isEmpty
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: sackList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final sack =
                                                          sackList[index];
                                                      return Column(
                                                        children: [
                                                          ListTile(
                                                            title: Text(
                                                              sack['sack_name'],
                                                              style: TextStyle(
                                                                  fontSize: 16),
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
                                                                      color: Colors
                                                                          .red),
                                                                  onPressed: () =>
                                                                      deleteSack(
                                                                          sack[
                                                                              'sack_id'],
                                                                          index),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .send,
                                                                      color: Colors
                                                                          .green),
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        'Submit ${sack['sack_name']}');
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () =>
                                                                showDialog(
                                                              context: context,
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
                                                          Divider(),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: ((context) {
                                              return AlertDialog(
                                                title: Text('Create Sack'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextFieldWidget(
                                                        controller: _sackId,
                                                        labelText:
                                                            'Enter Sack ID'),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value: _selectedArbiter,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Arbiter',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      items: _arbiterChoices
                                                          .map((choice) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: choice,
                                                          child: Text(choice),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedArbiter =
                                                              value;
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
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Close'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Add'),
                                                  ),
                                                ],
                                              );
                                            })),
                                        child: Text(
                                          'Add Sack',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pending approval',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(),
                                          bottom: BorderSide(),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Sack ID',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Status',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Requests',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(),
                                          bottom: BorderSide(),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Sack ID',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Status',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
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
          ],
        ),
      ),
    );
  }
}
