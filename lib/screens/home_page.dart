import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";

  String? _selectedArbiter;
  final TextEditingController _sackId = TextEditingController();

  final List<String> _arbiterChoices = ['Arbiter 1', 'Arbiter 2', 'Arbiter 3'];
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
                                decoration: InputDecoration(
                                  hintText: 'Search Document',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            color: Colors.grey[300],
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 500,
                                    height: 400,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            'Sack 1 example',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  print('Delete Sack 1');
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.send,
                                                    color: Colors.green),
                                                onPressed: () {
                                                  print('Submit Sack 1');
                                                },
                                              ),
                                            ],
                                          ),
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return SackContent();
                                              })),
                                        ),
                                        Divider(),
                                        ListTile(
                                          title: Text(
                                            'Sack 2 example',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  print('Delete Sack 2');
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.send,
                                                    color: Colors.green),
                                                onPressed: () {
                                                  print('Submit Sack 2');
                                                },
                                              ),
                                            ],
                                          ),
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return SackContent();
                                              })),
                                        ),
                                      ],
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
                                          title: Text('Create Sack'),
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
                                                value: _selectedArbiter,
                                                decoration: InputDecoration(
                                                  labelText: 'Arbiter',
                                                  border: OutlineInputBorder(),
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
                                                    _selectedArbiter = value;
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
                                                  foregroundColor:
                                                      Colors.white),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Close'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.greenAccent,
                                                  foregroundColor:
                                                      Colors.black),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Add'),
                                            ),
                                          ],
                                        );
                                      })),
                                  child: Text(
                                    '+ Sack',
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
                    SizedBox(
                      height: 300,
                      child: Card(
                        color: const Color.fromARGB(255, 25, 17, 134)
                            .withValues(alpha: 0.8),
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
                                    Text(
                                      'Sack ID',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
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
    );
  }
}
