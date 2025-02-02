import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/widgets/login_widget.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

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
        'doc_number': "RAB-IV-${_documentNumberController.text.trim()}",
        'doc_repondent': _respondentController.text.trim(),
        'doc_complainant': _comlainantController.text.trim(),
        'doc_verdict': _documentVerdictController.text.trim(),
        'status': 'Stored',
        'doc_version': user == null ? 'old' : 'new',
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
                TextFormField(
                  controller: _documentNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]')), // Allow only letters & numbers
                    CaseNumberFormatter()
                  ],
                  decoration: InputDecoration(
                    label: Text("Case Number"),
                    hintText: 'Enter Case Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Text(
                        "RAB-IV-: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Case Number';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => addDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _comlainantController,
                  hint: "Enter Complainant Name",
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
                  hint: "Enter Respondent Name",
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
                  labelText: 'Volume (Optional)',
                  hint: 'Enter Volume',
                  onFieldSubmitted: (_) => addDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _documentVerdictController,
                  labelText: 'Verdict (Optional)',
                  hint: "Enter Verdict",
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

class CaseNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if ((i == 2 || i == 7 || i == 9) && i < digitsOnly.length) {
        formatted += '-';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
