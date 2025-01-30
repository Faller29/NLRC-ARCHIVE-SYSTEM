import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/widgets/login_widget.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDocument extends StatefulWidget {
  final String sackId;
  final VoidCallback onDocumentAdded; // Callback to notify parent

  const AddDocument({
    Key? key,
    required this.sackId,
    required this.onDocumentAdded,
  }) : super(key: key);

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _comlainantController = TextEditingController();
  final TextEditingController _respondentController = TextEditingController();
  final TextEditingController _documentVerdictController =
      TextEditingController();
  final TextEditingController _documentVolumeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void addDocument(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'sack_id': widget.sackId,
        'doc_number': _documentNumberController.text.trim(),
        'doc_repondent': _respondentController.text.trim(),
        'doc_complainant': _comlainantController.text.trim(),
        'doc_verdict': _documentVerdictController.text.trim(),
        'status': 'Stored',
        'doc_version': adminType == null ? 'old' : 'new',
        'doc_volume': _documentVolumeController.text.trim(),
      };
      try {
        final response = await http.post(
          Uri.parse('http://localhost/nlrc_archive_api/add_document.php'),
          body: data,
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added Successfully')),
            );
            widget.onDocumentAdded();
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseData['message']}')),
            );
          }
        } else {
          throw Exception('Failed to connect to the server');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Case',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.sizeOf(context).width / 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldBoxWidget(
                  controller: _documentNumberController,
                  labelText: 'Case Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Document Number';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => addDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _comlainantController,
                  labelText: 'Complainant',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Complainant';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => addDocument(context),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'VERSUS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _respondentController,
                  labelText: 'Respondent',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Respondent';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => addDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _documentVolumeController,
                  labelText: 'Volume',
                  onFieldSubmitted: (_) => addDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _documentVerdictController,
                  labelText: 'Verdict (Optional)',
                  onFieldSubmitted: (_) => addDocument(context),
                )
              ],
            ),
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
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black),
          onPressed: () => addDocument(context),
          child: Text('Submit'),
        ),
      ],
    );
  }
}
