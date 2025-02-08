import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/modals/add_document.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';
import 'package:nlrc_archive/widgets/disposed_documents_widget.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";
  String? _selectedFileName;
  String? _selectedFilePath;

  String? _selectedArbiter;
  final TextEditingController _sackId = TextEditingController();
  TextEditingController rejectReason = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController disposeSearch = TextEditingController();

  int currentPage = 0;
  final int pageSize = 5;

  int currentDisposePage = 0;
  final int disposePageSize = 5;
  List<dynamic> _arbiterChoices = [];
  //List<Map<String, dynamic>> documents = [];
  late Timer _timer;

  @override
  void initState() {
    _selectedArbiter = user ?? null;
    _selectedArbiter1 = user ?? null;
    _selectedArbiter2 = user ?? null;
    _startPolling();
    fetchArbiters();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    query = '';
    disposeQuery = '';
    super.dispose();
  }

  String? _selectedArbiter2 = user;
  final String apiUrl =
      "http://$serverIP/nlrc_archive_api/generate_excel.php"; // Change this
  Future<void> generateExcel(
      BuildContext context, String selectedArbiter22) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Generating Excel File, Please wait..."),
              ],
            ),
          ),
        );
      },
    );

    // Fix: Check for both null and empty string
    if (_selectedArbiter2 == null) {
      Navigator.pop(context); // Close the dialog

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Please select an arbiter', context),
        );
      });
      return;
    }

    try {
      var response = await http.post(Uri.parse(apiUrl),
          body: {"selectedArbiter2": selectedArbiter22});

      if (response.statusCode == 200) {
        List<dynamic> sacks = json.decode(response.body);

        if (sacks.isEmpty) {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarFailed('No Data Found', context),
            );
          });

          return;
        }

        var excelFile = excel.Excel.createExcel();

        void setColumnWidths(excel.Sheet sheet) {
          sheet.setColWidth(0, 33);
          sheet.setColWidth(1, 83);
          sheet.setColWidth(2, 87.89);
          sheet.setColWidth(3, 15.33);
          sheet.setColWidth(4, 15.33);
          sheet.setColWidth(5, 10);
        }

        void applyHeaderStyle(excel.Sheet sheet) {
          var headerStyle = excel.CellStyle(
            horizontalAlign: excel.HorizontalAlign.Center,
            bold: true,
            fontSize: 11,
            fontFamily: "Arial",
          );

          for (int i = 0; i < 6; i++) {
            var cell = sheet.cell(
                excel.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
            cell.cellStyle = headerStyle;
          }
        }

        void applyContentStyle(excel.Sheet sheet, int rowCount) {
          var contentStyle = excel.CellStyle(
            fontSize: 11,
            fontFamily: "Arial",
            bold: false,
          );

          for (int row = 1; row < rowCount; row++) {
            for (int col = 0; col < 6; col++) {
              var cell = sheet.cell(excel.CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: row));
              cell.cellStyle = contentStyle;
            }
          }
        }

        for (var sack in sacks) {
          String sheetName = sack['sack_name'];
          var sheet = excelFile[sheetName];

          if (sheet.maxRows == 0) {
            sheet.appendRow([
              "Case Number",
              "Complainant",
              "Respondent",
              "Volume",
              "Verdict",
              "Version"
            ]);
            applyHeaderStyle(sheet);
          }

          for (var doc in sack['documents']) {
            sheet.appendRow([
              doc['doc_number'],
              doc['doc_complainant'],
              doc['doc_respondent'],
              doc['volume'],
              doc['verdict'],
              doc['version']
            ]);
          }

          setColumnWidths(sheet);
          applyContentStyle(sheet, sheet.maxRows);
        }

        // Close loader before showing save dialog
        Navigator.pop(context);

        String? outputFilePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Excel File',
          fileName: '$selectedArbiter22.xlsx',
          allowedExtensions: ['xlsx'],
          type: FileType.custom,
        );

        if (outputFilePath == null) {
          return; // User canceled, exit function
        }

        if (!outputFilePath.endsWith('.xlsx')) {
          outputFilePath = '$outputFilePath.xlsx';
        }

        final file = File(outputFilePath);
        await file.writeAsBytes(excelFile.encode()!);

// Reset state
        if (user == null) {
          setState(() {
            _selectedArbiter2 = null;
          });
        } else {
          _selectedArbiter2 = user;
        }

// Always show success snackbar regardless of overwrite
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarSuccess("Saved Successfully", context),
          );
          Navigator.pop(context);
        });
        try {
          OpenFile.open(outputFilePath);
        } catch (e) {
          print("Error opening file: $e");
        }
      } else {
        Navigator.pop(context);
        snackBarFailed("Error fetching data", context);
      }
    } catch (e) {
      Navigator.pop(context);
      snackBarFailed("Error: $e", context);
    }
  }

  void pickExcelFile(Function(void Function()) setState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path; // Save the file path
        _selectedFileName = result.files.single.name; // Save the file name
      });
      print("Selected Excel file path: $_selectedFilePath");
    } else {
      setState(() {
        _selectedFilePath = null;
        _selectedFileName = null;
      });
      print("File selection canceled");
    }
  }

  String? _selectedArbiter1 = user;

  Future<void> uploadExcelFile(Function(void Function()) setState) async {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Please select an Excel file first', context),
      );
      return;
    }

    if (_selectedArbiter1 == null || _selectedArbiter1!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Please select an arbiter', context),
      );
      return;
    }

    // Show progress indicator dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Uploading Excel File, Please wait..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$serverIP/nlrc_archive_api/upload_excel.php'),
      );

      request.fields['arbiter_number'] = _selectedArbiter1!;
      request.fields['account_id'] = accountId;
      request.fields['doc_version'] = user == null ? 'old' : 'new';
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedFilePath!,
      ));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      Navigator.pop(context); // Close the progress dialog

      if (jsonResponse['status'] == 'exists') {
        // Show alert dialog if sack name already exists
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Duplicate Sack Name"),
              content: Text(
                  "There is a sack name that already exists for this arbiter. Proceed anyway?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Close dialog
                  child: Text("Close"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _uploadFileAnyway(setState);
                    if (user == null) {
                      setState(() {
                        _selectedFileName = null;
                        _selectedFilePath = null;
                        _selectedArbiter1 = null;
                      });
                    } else {
                      _selectedFileName = null;
                      _selectedFilePath = null;
                    }
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarSuccess('File has been saved', context),
        );

        if (user == null) {
          setState(() {
            _selectedFileName = null;
            _selectedFilePath = null;
            _selectedArbiter1 = null;
          });
        } else {
          _selectedFileName = null;
          _selectedFilePath = null;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Failed to save', context),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close the progress dialog
      print("Error during upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error uploading file', context),
      );
    }
  }

  Future<void> _uploadFileAnyway(Function(void Function()) setState) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$serverIP/nlrc_archive_api/upload_excel_anyway.php'),
      );

      request.fields['arbiter_number'] = _selectedArbiter1!;
      request.fields['account_id'] = accountId;
      request.fields['doc_version'] = user == null ? 'old' : 'new';
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedFilePath!,
      ));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarSuccess('File has been saved', context),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Failed to save', context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error uploading file', context),
      );
    }
  }

  Future<void> fetchArbiters() async {
    final url = "http://$serverIP/nlrc_archive_api/get_arbi_choices.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          if (data.isNotEmpty) {
            _arbiterChoices =
                data.map((arbiter) => arbiter['arbi_name']).toList();
          } else {
            print('No arbiters found');
          }
        });
      } else {
        throw Exception('Failed to load arbiters');
      }
    } catch (error) {
      print("Error fetching arbiters: $error");
    }
  }

  Future<void> addSack() async {
    print(accountId.runtimeType);

    if (_sackId.text.isEmpty ||
        _selectedArbiter == null ||
        _selectedArbiter!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed(
            'Please enter a sack name and select an arbiter number', context),
      );
      return;
    }

    var url = "http://$serverIP/nlrc_archive_api/add_sack.php";
    var response = await http.post(Uri.parse(url), body: {
      "sack_name": "Sack ${_sackId.text}",
      "arbiter_number": _selectedArbiter,
      "sack_status": 'Creating',
      "acc_id": accountId,
    });

    var data = jsonDecode(response.body);

    if (data['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarSuccess('Added Sack Successfully', context),
      );
      setState(() {
        sackCreatedList.add({
          "sack_id": data['sack_id'].toString(),
          "sack_name": _sackId.text,
          "arbiter_number": _selectedArbiter,
        });
      });
      _sackId.clear();
      if (user == null) {
        _selectedArbiter = null;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Failed to Add Sack', context),
      );
    }
    Navigator.pop(context);
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
          snackBarSuccess('Deleted Successfully', context),
        );
        setState(() {
          sackCreatedList.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Failed to Delete', context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error: $e', context),
      );
    }
    Navigator.pop(context);
  }

  Future<void> updateSackStatus(String sackId) async {
    var url = "http://$serverIP/nlrc_archive_api/update_sack_status.php";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'sack_id': sackId,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarSuccess(data['message'], context),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarFailed(data['message'], context),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Failed to update sack status', context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error: $e', context),
      );
    }
  }

  Future<void> rejectPending(sackId) async {
    var url = "http://$serverIP/nlrc_archive_api/reject_sack.php";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'sack_id': sackId,
          'reject_message': rejectReason.text,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarSuccess(data['message'], context),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarFailed(data['message'], context),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Failed to reject sack status', context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Error: $e', context),
      );
    }
  }

  _startPolling() async {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (!isFetching) {
        fetchDocuments(query, user).then((data) {
          if (!listsAreEqual(documents, data)) {
            if (mounted) {
              setState(() {
                documents = data;
              });
            }
          }
        });

        fetchCreatedSack().then((data) {
          if (!listsAreEqual(sackCreatedList, data)) {
            if (mounted) {
              setState(() {
                sackCreatedList = data;
              });
            }
          }
        });

        fetchPendingSack().then((data) {
          if (!listsAreEqual(sackPendingList, data)) {
            if (mounted) {
              setState(() {
                sackPendingList = data;
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
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/NLRCnbg.png',
                                fit: BoxFit.scaleDown,
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 2 -
                                      100,
                                  child: Center(
                                    child: Text(
                                      'Find Document',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.sizeOf(context).width / 2 - 100,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 51, 38, 165),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DocumentDialog();
                                              },
                                            ),
                                        child: Text('Disposed'))),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2 - 100,
                              child: TextField(
                                controller: search,
                                onChanged: (value) {
                                  setState(() {
                                    query = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      'Search Case number, Complainant, or Respondent',
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: InkWell(
                                    child: ClipRRect(
                                        child: Icon(
                                      Icons.cancel_sharp,
                                      size: 26,
                                    )),
                                    onTap: () {
                                      search.clear();
                                      setState(() {
                                        query = '';
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              width: 600,
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: fetchDocuments(query, user),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                        child: Text('No documents found.'));
                                  }

                                  documents = snapshot.data!;
                                  documents.sort((a, b) {
                                    return (a['doc_complainant'] ?? '')
                                        .compareTo(b['doc_complainant'] ?? '');
                                  });

                                  // Pagination logic
                                  int totalPages =
                                      (documents.length / pageSize).ceil();
                                  int startIndex = currentPage * pageSize;
                                  int endIndex = startIndex + pageSize;
                                  List<Map<String, dynamic>> visibleDocuments =
                                      documents.sublist(
                                          startIndex,
                                          endIndex > documents.length
                                              ? documents.length
                                              : endIndex);

                                  return Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: visibleDocuments.length,
                                          itemBuilder: (context, index) {
                                            final doc = visibleDocuments[index];

                                            final sackName = doc['sack_name'] ??
                                                'No Sack Name';
                                            final doc_complainant =
                                                doc['doc_complainant'] ??
                                                    'No complainant';
                                            final doc_respondent =
                                                doc['doc_respondent'] ??
                                                    'No respondent';
                                            final docStatus =
                                                doc['status'] ?? 'Unknown';
                                            final verdict =
                                                "${doc['verdict']!.isEmpty ? 'No Decision' : doc['verdict']}";
                                            final arbiName = doc['arbi_name'] ??
                                                'No arbiter';
                                            final docId = doc['doc_id'] ??
                                                'No document Id';

                                            String docName =
                                                doc['doc_number'] ??
                                                    'No document name';
                                            String docVolume =
                                                "${doc['doc_volume']!.isEmpty ? 'No volume' : doc['doc_volume']}";
                                            String version =
                                                "${doc['version']}" ?? 'No';

                                            return Card(
                                              color: Colors.grey[300],
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16.0,
                                                    top: 5.0,
                                                    left: 16.0,
                                                    right: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Case #: ${docName.toUpperCase()}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                        Text(
                                                          "${arbiName.toUpperCase()} - ${sackName.toUpperCase()}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 25, 94, 8),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Tooltip(
                                                              message:
                                                                  doc_complainant,
                                                              child: SizedBox(
                                                                width: 400,
                                                                child: Text(
                                                                  doc_complainant,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "vs.",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 0.8,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                            Tooltip(
                                                              message:
                                                                  doc_respondent,
                                                              child: SizedBox(
                                                                width: 400,
                                                                child: Text(
                                                                  doc_respondent,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 12.0,
                                                            vertical: 6.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: docStatus ==
                                                                    'Stored'
                                                                ? Colors
                                                                    .green[100]
                                                                : docStatus ==
                                                                        'Requested'
                                                                    ? Colors.blue[
                                                                        100]
                                                                    : Colors.red[
                                                                        100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          child: Text(
                                                            docStatus,
                                                            style: TextStyle(
                                                              color: docStatus ==
                                                                      'Stored'
                                                                  ? Colors.green[
                                                                      800]
                                                                  : docStatus ==
                                                                          'Requested'
                                                                      ? Colors.blue[
                                                                          800]
                                                                      : Colors.red[
                                                                          800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 18.0),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.book,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 16,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          'Volume: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                        Text(
                                                          '${docVolume}',
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.storage,
                                                                size: 16,
                                                                color: Colors
                                                                    .grey[600]),
                                                            const SizedBox(
                                                                width: 6.0),
                                                            Text(
                                                              'Arbiter: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                            Text(
                                                              arbiName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                                width: 6.0),
                                                            Text(
                                                              'Storage: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                            Text(
                                                              sackName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.gavel,
                                                                size: 16,
                                                                color: Colors
                                                                    .grey[600]),
                                                            const SizedBox(
                                                                width: 6.0),
                                                            Text(
                                                              'Decision: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                            Text(verdict),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "${version.capitalize()} version",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white),
                                                              onPressed: () =>
                                                                  showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AddEditDocument(
                                                                    sackId: doc[
                                                                            'sack_id']
                                                                        .toString(),
                                                                    onDocumentUpdated:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        //ref
                                                                      });
                                                                    },
                                                                    document:
                                                                        doc,
                                                                  );
                                                                },
                                                              ),
                                                              child: Text(
                                                                "Edit",
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            if (user == null)
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white),
                                                                onPressed: () =>
                                                                    showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      ((context) {
                                                                    return AlertDialog(
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              40,
                                                                          horizontal:
                                                                              30),
                                                                      title: Text(
                                                                          'Delete ${doc['doc_number']}'),
                                                                      content: Text(
                                                                          'Are you sure you want to dispose Document ${doc['doc_number']}?'),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.redAccent,
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          child:
                                                                              Text('Cancel'),
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            bool
                                                                                success =
                                                                                await disposeDocument(docId, accountId);

                                                                            if (success) {
                                                                              setState(() {});
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                snackBarSuccess(
                                                                                  'Retrieval request sent!',
                                                                                  context,
                                                                                ),
                                                                              );
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                snackBarFailed('Failed to request retrieval', context),
                                                                              );
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Confirm'),
                                                                        ),
                                                                      ],
                                                                      actionsAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                    );
                                                                  }),
                                                                ),
                                                                child: Text(
                                                                  "Dispose",
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        if (docStatus ==
                                                            "Stored")
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        51,
                                                                        38,
                                                                        165),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white),
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      '$docName',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    content:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          'Request archive for retrieval',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            foregroundColor: Colors.white),
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child: Text(
                                                                            'Cancel'),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            foregroundColor: Colors.white),
                                                                        onPressed:
                                                                            () async {
                                                                          if (docStatus ==
                                                                              'Stored') {
                                                                            bool
                                                                                success =
                                                                                await requestRetrieval(docId, accountId);

                                                                            if (success) {
                                                                              setState(() {});
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                snackBarSuccess(
                                                                                  'Retrieval request sent!',
                                                                                  context,
                                                                                ),
                                                                              );
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                snackBarFailed('Failed to request retrieval', context),
                                                                              );
                                                                            }
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              snackBarFailed(
                                                                                'Case not in Archive',
                                                                                context,
                                                                              ),
                                                                            );
                                                                          }

                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            'Confirm'),
                                                                      ),
                                                                    ],
                                                                    actionsAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child:
                                                                Text('Request'),
                                                          ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      // Pagination controls
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: currentPage > 0
                                                ? () {
                                                    setState(() {
                                                      currentPage--;
                                                    });
                                                  }
                                                : null,
                                            icon: Icon(Icons.arrow_left),
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                              "Page ${currentPage + 1} of $totalPages"),
                                          SizedBox(width: 16),
                                          IconButton(
                                              onPressed:
                                                  currentPage < totalPages - 1
                                                      ? () {
                                                          setState(() {
                                                            currentPage++;
                                                          });
                                                        }
                                                      : null,
                                              icon: Icon(Icons.arrow_right))
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
                          child: Column(
                            children: [
                              Text(
                                'Archive Document',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Tooltip(
                                    message:
                                        "This will generate an excel file that contains\nall the Documents of the selected arbiter",
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 51, 38, 165),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        Text('Generate Excel'),
                                                  ),
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: _selectedArbiter2,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Arbiter',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      items: (user == null
                                                              ? _arbiterChoices
                                                              : [user])
                                                          .map((choice) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: choice,
                                                          child: Text(choice),
                                                        );
                                                      }).toList(),
                                                      onChanged: user == null
                                                          ? (value) {
                                                              setState(() {
                                                                _selectedArbiter2 =
                                                                    value;
                                                                print(
                                                                    "Selected Arbiter: $_selectedArbiter2");
                                                              });
                                                            }
                                                          : null,
                                                      isExpanded: true,
                                                      disabledHint: user != null
                                                          ? Text(user)
                                                          : null,
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Close'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        // Action for generate button
                                                        generateExcel(
                                                            context,
                                                            _selectedArbiter2 ??
                                                                '');
                                                      },
                                                      child: Text('Generate'),
                                                    ),
                                                  ],
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Generate',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  //if (user == null)
                                  Tooltip(
                                    message:
                                        "This will automatically upload all the data of\ndocument cases in your excel file into the database",
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 51, 38, 165),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Upload Excel File'),
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "REMINDER",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      /* textAlign:
                                                                          TextAlign
                                                                              .center, */
                                                                    ),
                                                                    content:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "1. Make sure to follow this format for the contents in the excel file:",
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/excel_img/format.png',
                                                                          width:
                                                                              500,
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                        ),
                                                                        Text(
                                                                          "Each data shall be placed under the correct column",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black87,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        Text(
                                                                            "2. Make sure to follow the correct format of case number"),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          "   Example: RAB-IV-8-16088-02-L",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "Do not forget to include RAB-IV in the case number",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black87,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context),
                                                                          child:
                                                                              Text(
                                                                            "Close",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ))
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          icon:
                                                              Icon(Icons.help))
                                                    ],
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 250,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border:
                                                                    Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green,
                                                                )),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  _selectedFileName !=
                                                                          null
                                                                      ? 'File: $_selectedFileName'
                                                                      : 'No file selected',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            if (_selectedFileName !=
                                                                null)
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _selectedFileName =
                                                                        null;
                                                                  });
                                                                },
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          pickExcelFile(
                                                              setState);
                                                        },
                                                        child: Text(
                                                            'Select Excel File'),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          value:
                                                              _selectedArbiter1,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Arbiter',
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          items: (user == null
                                                                  ? _arbiterChoices
                                                                  : [user])
                                                              .map((choice) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: choice,
                                                              child:
                                                                  Text(choice),
                                                            );
                                                          }).toList(),
                                                          onChanged: user ==
                                                                  null
                                                              ? (value) {
                                                                  setState(() {
                                                                    _selectedArbiter1 =
                                                                        value;
                                                                    print(
                                                                        "Selected Arbiter: $_selectedArbiter1");
                                                                  });
                                                                }
                                                              : null,
                                                          isExpanded: true,
                                                          disabledHint:
                                                              user != null
                                                                  ? Text(user)
                                                                  : null,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .redAccent,
                                                              foregroundColor:
                                                                  Colors.white),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Close'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              foregroundColor:
                                                                  Colors.white),
                                                      onPressed: () {
                                                        uploadExcelFile(
                                                            setState);
                                                      },
                                                      child: Text('Save'),
                                                    ),
                                                  ],
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                );
                                              },
                                            );
                                          },
                                        ).then((_) {
                                          setState(() {
                                            //ref
                                          });
                                        });
                                      },
                                      child: Text(
                                        '+ Auto',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Tooltip(
                                    message: "Manually add sack and documents",
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent,
                                      ),
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Create Sack'),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        label:
                                                            Text("Sack Number"),
                                                        hintText:
                                                            'Enter Sack Number',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 14),
                                                          child: Text(
                                                            "Sack: ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        14),
                                                        labelStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      controller: _sackId,
                                                    ),
                                                    SizedBox(height: 20),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value: _selectedArbiter,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Arbiter',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      items: (user == null
                                                              ? _arbiterChoices
                                                              : [user])
                                                          .map((choice) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: choice,
                                                          child: Text(choice),
                                                        );
                                                      }).toList(),
                                                      onChanged: user == null
                                                          ? (value) {
                                                              setState(() {
                                                                _selectedArbiter =
                                                                    value;
                                                                print(
                                                                    "Selected Arbiter: $_selectedArbiter");
                                                              });
                                                            }
                                                          : null,
                                                      isExpanded: true,
                                                      disabledHint: user != null
                                                          ? Text(user)
                                                          : null,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Close'),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    onPressed: addSack,
                                                    child: Text('Add'),
                                                  ),
                                                ],
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                              );
                                            },
                                          );
                                        },
                                      ),
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
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width / 2 -
                                      100,
                                  child: FutureBuilder<List<dynamic>>(
                                      future: fetchCreatedSack(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                              child: Text(
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                  'There is no records found'));
                                        }
                                        sackCreatedList = snapshot.data!;
                                        return sackCreatedList.isEmpty
                                            ? Center(
                                                child: Text(
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                    'There is no records found'))
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    sackCreatedList.length,
                                                itemBuilder: (context, index) {
                                                  final sack =
                                                      sackCreatedList[index];

                                                  bool isRejected =
                                                      sack['status'] ==
                                                          'Reject';

                                                  return Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: isRejected
                                                              ? Colors.red
                                                              : Colors
                                                                  .green[200],
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            sack['sack_name'] ??
                                                                'No Sack Name',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: isRejected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                sack['arbiter_number'] ??
                                                                    'No Arbiter Name',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: isRejected
                                                                      ? Colors
                                                                          .white70
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              if (isRejected)
                                                                Text(
                                                                  "Rejected: ${sack['admin_message'] ?? 'No reason provided'}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .white70,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          trailing: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: isRejected
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .red,
                                                                ),
                                                                onPressed: () =>
                                                                    showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      ((context) {
                                                                    return AlertDialog(
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              40,
                                                                          horizontal:
                                                                              30),
                                                                      title: Text(
                                                                          'Delete ${sack['sack_name']}'),
                                                                      content: Text(
                                                                          'Are you sure you want to delete SACK ${sack['sack_name']}?'),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.redAccent,
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          child:
                                                                              Text('Cancel'),
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          onPressed: () =>
                                                                              deleteSack(
                                                                            sack['sack_id'].toString(),
                                                                            index,
                                                                          ),
                                                                          child:
                                                                              Text('Confirm'),
                                                                        ),
                                                                      ],
                                                                      actionsAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                    );
                                                                  }),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.send,
                                                                  color: isRejected
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .green,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  final sackId =
                                                                      sack['sack_id']
                                                                          .toString();
                                                                  final response =
                                                                      await sendForApproval(
                                                                          sackId);

                                                                  if (response[
                                                                          'status'] ==
                                                                      'success') {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      snackBarSuccess(
                                                                          'Sack sent for approval',
                                                                          context),
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      sack['status'] =
                                                                          'pending';
                                                                    });
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      snackBarFailed(
                                                                          '${response['message']}',
                                                                          context),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () =>
                                                              showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SackContent(
                                                                sackId: sack[
                                                                    'sack_id'],
                                                                sackName: sack[
                                                                    'sack_name'],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(),
                                                    ],
                                                  );
                                                },
                                              );
                                      }),
                                ),
                              )
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
                                'Pending Approval',
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
                                    Expanded(
                                      child: Text(
                                        'Sack #',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Arbiter',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    if (user == null)
                                      Expanded(
                                        child: Text(
                                          'Action',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: FutureBuilder<List<dynamic>>(
                                    future: fetchPendingSack(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Center(
                                          child: Text(
                                            'No pending sacks found.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ));
                                      }
                                      sackPendingList = snapshot.data!;
                                      return ListView.builder(
                                        itemCount: sackPendingList.length,
                                        itemBuilder: (context, index) {
                                          final sack = sackPendingList[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        child: Icon(
                                                          Icons.visibility,
                                                          color: Colors.white,
                                                        ),
                                                        onTap: () => showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return SackContent(
                                                                sackId: sack[
                                                                    'sack_id'],
                                                                sackName: sack[
                                                                    'sack_name'],
                                                                pending:
                                                                    "pending");
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${sack['sack_name']}" ??
                                                            'N/A',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    sack['arbiter_number'] ??
                                                        'N/A',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                if (user == null)
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                          onPressed: () async {
                                                            final sackId =
                                                                sack['sack_id'];
                                                            if (sackId !=
                                                                null) {
                                                              await updateSackStatus(
                                                                      sackId)
                                                                  .then(
                                                                      (_) async {
                                                                setState(() {
                                                                  //ref
                                                                });
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            final sackId =
                                                                sack['sack_id'];
                                                            if (sackId !=
                                                                null) {
                                                              await rejectSack(
                                                                      sackId)
                                                                  .then(
                                                                      (_) async {
                                                                setState(() {
                                                                  //ref
                                                                });
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }),
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

  Future<void> rejectSack(String sackId) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reason for Rejection'),
          content: SizedBox(
            width: 400,
            child: TextField(
              controller: rejectReason,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter reason for rejection",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                labelStyle: TextStyle(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                rejectReason.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () async {
                await rejectPending(sackId).then((_) {
                  setState(() {
                    //ref
                  });
                });
                rejectReason.clear();
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
