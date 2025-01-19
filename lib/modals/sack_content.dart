import 'package:flutter/material.dart';
import 'package:nlrc_archive/modals/add_document.dart';

class SackContent extends StatefulWidget {
  @override
  State<SackContent> createState() => _SackContentState();
}

class _SackContentState extends State<SackContent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sack ID'),
      content: Card(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('List ng data na nasa sack ay ilalagay dito')],
          ),
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
              builder: ((context) {
                return AddDocument();
              })),
          child: Text('Add'),
        ),
      ],
    );
  }
}
