import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/widgets/login_widget.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class AddEditDocument extends StatefulWidget {
  final String sackId;
  final VoidCallback onDocumentUpdated;
  final Map<String, dynamic>? document;

  const AddEditDocument({
    Key? key,
    required this.sackId,
    required this.onDocumentUpdated,
    this.document,
  }) : super(key: key);

  @override
  State<AddEditDocument> createState() => _AddEditDocumentState();
}

class _AddEditDocumentState extends State<AddEditDocument> {
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _complainantController = TextEditingController();
  final TextEditingController _respondentController = TextEditingController();
  final TextEditingController _documentVerdictController =
      TextEditingController();
  final TextEditingController _documentVolumeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      _documentNumberController.text =
          widget.document!['doc_number']?.replaceFirst("RAB-IV-", "") ?? '';
      _complainantController.text = widget.document!['doc_complainant'] ?? '';
      _respondentController.text = widget.document!['doc_respondent'] ?? '';
      _documentVerdictController.text = widget.document!['verdict'] ?? '';
      _documentVolumeController.text = widget.document!['doc_volume'] ?? '';
    }
  }

  void saveDocument(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'sack_id': widget.sackId,
      'doc_number': "RAB-IV-${_documentNumberController.text.trim()}",
      'doc_respondent': _respondentController.text.trim(),
      'doc_complainant': _complainantController.text.trim(),
      'doc_verdict': _documentVerdictController.text.trim(),
      'status': 'Stored',
      'doc_version': user == null ? 'old' : 'new',
      'doc_volume': _documentVolumeController.text.trim(),
    };
    print(widget.document!['doc_id']);
    print(widget.sackId);
    print("nm${_documentNumberController.text}");

    print("vol${_documentVolumeController.text}");
    print("ver${_documentVerdictController.text}");
    print("respo${_respondentController.text}");
    print("Complainant${_complainantController.text}");

    try {
      final response = await http.post(
        Uri.parse(widget.document == null
            ? 'http://$serverIP/nlrc_archive_api/add_document.php'
            : 'http://$serverIP/nlrc_archive_api/edit_document.php'),
        body: widget.document == null
            ? data
            : {...data, 'doc_id': widget.document!['doc_id']},
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarSuccess(
              widget.document == null
                  ? 'Added Successfully'
                  : 'Updated Successfully',
              context),
        );
        widget.onDocumentUpdated();
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed(
              widget.document == null ? 'Failed to Add' : 'Failed to Update',
              context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error: ${e.toString()}', context),
      );
    }
  }

  /* void addDocument(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'sack_id': widget.sackId,
        'doc_number': "RAB-IV-${_documentNumberController.text.trim()}",
        'doc_repondent': _respondentController.text.trim(),
        'doc_complainant': _complainantController.text.trim(),
        'doc_verdict': _documentVerdictController.text.trim(),
        'status': 'Stored',
        'doc_version': user == null ? 'old' : 'new',
        'doc_volume': _documentVolumeController.text.trim(),
      };
      try {
        final response = await http.post(
          Uri.parse('http://$serverIP/nlrc_archive_api/add_document.php'),
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
  } */

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Document',
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
                        "RAB-IV- ",
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
                  onFieldSubmitted: (_) => saveDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _complainantController,
                  hint: "Enter Complainant Name",
                  labelText: 'Complainant',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Complainant';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => saveDocument(context),
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
                  onFieldSubmitted: (_) => saveDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _documentVolumeController,
                  labelText: 'Volume (Optional)',
                  hint: 'Enter Volume',
                  onFieldSubmitted: (_) => saveDocument(context),
                ),
                const SizedBox(height: 16.0),
                TextFieldBoxWidget(
                  controller: _documentVerdictController,
                  labelText: 'Latest Decision (Optional)',
                  hint: "Enter Verdict",
                  onFieldSubmitted: (_) => saveDocument(context),
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
          onPressed: () => saveDocument(context),
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

    if (digitsOnly.length >= 3 && RegExp(r'^[A-Z]{3}').hasMatch(digitsOnly)) {
      // Case when first 3 characters are letters
      formatted = '${digitsOnly.substring(0, 3)}-';
      digitsOnly =
          digitsOnly.substring(3); // Remove first 3 letters from processing
    }

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
