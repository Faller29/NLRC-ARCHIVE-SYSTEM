import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nlrc_archive/widgets/login_widget.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';

class AddDocument extends StatefulWidget {
  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _documentTitleController =
      TextEditingController();
  String? _selectedArbiter;
  final _formKey = GlobalKey<FormState>();

  final List<String> _arbiterChoices = ['Arbiter 1', 'Arbiter 2', 'Arbiter 3'];

  void addDocument() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Document',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFieldWidget(
                controller: _documentNumberController,
                labelText: 'Document Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Document Number';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFieldWidget(
                controller: _documentTitleController,
                labelText: 'Document Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Document Title';
                  }

                  return null;
                },
                onFieldSubmitted: (_) => null,
              ),
              const SizedBox(
                height: 16.0,
                width: 300,
              ),
              DropdownButtonFormField<String>(
                value: _selectedArbiter,
                decoration: InputDecoration(
                  labelText: 'Arbiter',
                  border: OutlineInputBorder(),
                ),
                items: _arbiterChoices.map((choice) {
                  return DropdownMenuItem<String>(
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
                  if (value == null || value.isEmpty) {
                    return 'Please select an arbiter';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => addDocument(),
          child: Text('Submit'),
        ),
      ],
    );
  }
}
