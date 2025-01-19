import 'package:flutter/material.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final TextEditingController _sackId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text('Arbiters'),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text('Received'),
              ),
            ),
          ],
        ),
        Flexible(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Archive Document',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width / 2 - 100,
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
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      print('Delete Sack 1');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send, color: Colors.green),
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
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      print('Delete Sack 2');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send, color: Colors.green),
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
                              content: TextFieldWidget(
                                  controller: _sackId,
                                  labelText: 'Enter Sack ID'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
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
        )
      ],
    );
  }
}
