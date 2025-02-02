import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/data/themeData.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';
import 'package:http/http.dart' as http;

late List<Map<String, dynamic>> arbiters;
late List<Map<String, dynamic>> fetchedAccounts;
late List<Map<String, dynamic>> accounts;

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _retrievedDocuments = [];
  List<Map<String, dynamic>> _filteredDocuments = [];
  @override
  void initState() {
    _fetchDocuments();
    super.initState();
  }

  Future<void> _fetchDocuments() async {
    List<Map<String, dynamic>> documents = await fetchRetrievedDocuments();
    setState(() {
      _retrievedDocuments = documents;
      _filteredDocuments = documents;
    });
  }

  void _filterDocuments(String query) {
    setState(() {
      _filteredDocuments = _retrievedDocuments.where((doc) {
        String caseNumber = doc['doc_number'].toString().toLowerCase();
        String complainant = doc['doc_complainant'].toString().toLowerCase();
        String respondent = doc['doc_respondent'].toString().toLowerCase();

        return caseNumber.contains(query.toLowerCase()) ||
            complainant.contains(query.toLowerCase()) ||
            respondent.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteArbiter(String arbiId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/nlrc_archive_api/delete_arbiter.php'),
        body: {'arbi_id': arbiId},
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            snackBarSuccess('Arbiter added successfully!', context));
        fetchArbitersList();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarFailed('${data['message']}', context));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarFailed('$error', context));
    }
  }

  Future<void> deleteAccount(String accountId) async {
    final url = 'http://localhost/nlrc_archive_api/delete_user.php';
    try {
      final response = await http.post(Uri.parse(url), body: {
        'acc_id': accountId,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              snackBarSuccess('Account deleted successfully!', context));
        } else {
          throw Exception('Failed to delete account');
        }
      } else {
        throw Exception('Failed to delete account: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarFailed('Failed to delete account', context));
    }
  }

  Future<void> editAccount(String accountId, String username, String password,
      String? arbiId) async {
    final url = 'http://localhost/nlrc_archive_api/edit_account.php';
    try {
      final response = await http.post(Uri.parse(url), body: {
        'acc_id': accountId,
        'username': username,
        'password': password,
        'arbi_id': arbiId ?? 'null',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              snackBarSuccess('Account updated successfully!', context));
        } else {
          throw Exception('Failed to update account');
        }
      } else {
        throw Exception('Failed to update account: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to update account: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarFailed('Failed to update account', context));
    }
  }

  Future<void> addAccount(
      String username, String password, String? arbiterId) async {
    final url = 'http://localhost/nlrc_archive_api/add_account.php';

    String arbiIdToSend = arbiterId == null ? 'NULL' : arbiterId;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'username': username,
          'password': password,
          'arbi_id': arbiIdToSend,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              snackBarSuccess('Account added successfully', context));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarFailed('Failed to add account', context));
        }
      } else {
        throw Exception('Failed to make request: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarFailed('Something went wrong', context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'Manage Accounts & Arbiters',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Arbiters',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          IconButton(
                                            onPressed: () {
                                              _showAddArbiterDialog(context);
                                            },
                                            icon: Icon(Icons.add),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: FutureBuilder<
                                            List<Map<String, dynamic>>>(
                                          future: getArbiters(),
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
                                                      'No arbiters found'));
                                            } else {
                                              final arbiters = snapshot.data!;

                                              return ListView.builder(
                                                itemCount: arbiters.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    color: const Color.fromARGB(
                                                        255, 204, 224, 224),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor: Colors
                                                            .blueGrey[700],
                                                        child: Text(
                                                          arbiters[index]
                                                              ['name']![0],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      title: Text(
                                                          arbiters[index]
                                                              ['name']!),
                                                      subtitle: Text(
                                                          'Room: ${arbiters[index]['room']}'),
                                                      trailing: IconButton(
                                                        icon: Icon(Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () =>
                                                            showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Confirm Deletion'),
                                                              content: Text(
                                                                'Are you sure you want to delete this item? This action cannot be undone.',
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await deleteArbiter(
                                                                        arbiters[index]
                                                                            [
                                                                            'arbi_id']);

                                                                    setState(
                                                                        () {});

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'Delete'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(thickness: 2, height: 30),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Accounts',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          IconButton(
                                            onPressed: () {
                                              _showAddAccountDialog(context);
                                            },
                                            icon: Icon(Icons.add),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                        future: getAccounts(),
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
                                                child:
                                                    Text('No accounts found.'));
                                          } else {
                                            List<Map<String, dynamic>>
                                                accounts = snapshot.data!;

                                            return Expanded(
                                              child: ListView.builder(
                                                itemCount: accounts.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    color: const Color.fromARGB(
                                                        255, 204, 224, 224),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: ListTile(
                                                      leading: Icon(
                                                          Icons.person,
                                                          color: Colors.black),
                                                      title: Text(
                                                          accounts[index]
                                                              ['username']!),
                                                      subtitle: Text(
                                                        accounts[index][
                                                                    'arbi_id'] !=
                                                                null
                                                            ? 'Arbiter: ${accounts[index]['arbi_name']}'
                                                            : 'Admin Account',
                                                      ),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () {
                                                              _showEditAccountDialog(
                                                                  context,
                                                                  accounts[
                                                                      index]);
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red),
                                                            onPressed: () {
                                                              String accountId =
                                                                  accounts[
                                                                          index]
                                                                      [
                                                                      'acc_id']!;
                                                              _showDeleteConfirmation(
                                                                  context,
                                                                  accountId);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
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
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Retrieved Documents',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),

                                // 🔍 SEARCH BAR
                                TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search Case #, Complainant, or Respondent',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: _filterDocuments,
                                ),

                                SizedBox(height: 10),

                                Expanded(
                                  child: _filteredDocuments.isEmpty
                                      ? Center(
                                          child: Text(
                                              'No matching documents found'))
                                      : ListView.builder(
                                          itemCount: _filteredDocuments.length,
                                          itemBuilder: (context, index) {
                                            var retrieved =
                                                _filteredDocuments[index];
                                            return Card(
                                              color: Colors.grey[300],
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.book,
                                                            size: 16),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          "Case #: ${retrieved['doc_number']}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          child: Tooltip(
                                                            message: retrieved[
                                                                'doc_complainant'],
                                                            child: Text(
                                                              '${retrieved['doc_complainant']}',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'vs',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            height: 0.7,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Tooltip(
                                                          message: retrieved[
                                                              'doc_respondent'],
                                                          child: Text(
                                                            '${retrieved['doc_respondent']}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "${retrieved['timestamp']}"),
                                                        ElevatedButton.icon(
                                                          onPressed: () =>
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      ((context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Case #: ${retrieved['doc_number']}"),
                                                                      content: Text(
                                                                          'Archive Case #: ${retrieved['doc_number']}?'),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.red,
                                                                              foregroundColor: Colors.white),
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          child:
                                                                              Text("Cancel"),
                                                                        ),
                                                                        ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                                                            onPressed: () async {
                                                                              await updateDocumentStatus(retrieved['doc_id'], "Stored");
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                snackBarSuccess('Archived Successfully', context),
                                                                              );
                                                                              Navigator.pop(context);
                                                                              _fetchDocuments();
                                                                            },
                                                                            child: Text("Confirm"))
                                                                      ],
                                                                    );
                                                                  })),
                                                          icon: Icon(
                                                              Icons.archive,
                                                              color:
                                                                  Colors.white),
                                                          label:
                                                              Text("Archive"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blueGrey,
                                                            foregroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _showAddAccountDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String username = '';
    String password = '';
    String? selectedArbiterId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Account'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSaved: (value) => username = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSaved: (value) => password = value!,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: getArbiters(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final arbiters = snapshot.data ?? [];

                        if (arbiters.isEmpty) {
                          return Text('No arbiters available');
                        }

                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          isExpanded: true,
                          value: selectedArbiterId,
                          hint: Text('Select Arbiter'),
                          onChanged: (newValue) {
                            setState(() {
                              selectedArbiterId = newValue;
                            });
                            print(selectedArbiterId);
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('Admin'),
                            ),
                            ...arbiters
                                .map<DropdownMenuItem<String>>((arbiter) {
                              return DropdownMenuItem<String>(
                                value: arbiter['arbi_id'].toString(),
                                child: Text(arbiter['name']),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (selectedArbiterId == null) {
                    await addAccount(username, password, null);
                  } else {
                    await addAccount(username, password, selectedArbiterId);
                  }
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddArbiterDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController roomController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Arbiter"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                child: TextFieldBoxWidget(
                  controller: nameController,
                  labelText: "Arbiter Name",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextFieldBoxWidget(
                  controller: roomController,
                  labelText: "Room",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                String name = nameController.text.trim();
                String room = roomController.text.trim();

                if (name.isNotEmpty && room.isNotEmpty) {
                  addArbiter(name, room).then((success) {
                    setState(() {
                      //refresh
                    });
                    if (success) {
                      fetchArbitersList();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Arbiter added successfully!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add arbiter.")),
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields.")),
                  );
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String accountId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete this account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await deleteAccount(accountId);

                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditAccountDialog(
      BuildContext context, Map<String, dynamic> account) {
    TextEditingController usernameController =
        TextEditingController(text: account['username']);
    TextEditingController passwordController =
        TextEditingController(text: account['password']);

    // Check if the account has an arbi_id, if not it's admin.
    String? selectedArbiter =
        account['arbi_id'] != null ? account['arbi_id'].toString() : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                child: TextFieldBoxWidget(
                  controller: usernameController,
                  labelText: 'Username',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextFieldBoxWidget(
                  controller: passwordController,
                  obscureText: true,
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                value: selectedArbiter,
                hint: Text('Select Arbiter'),
                items: [
                  // Add "Admin" option if selectedArbiter is null
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('Admin'),
                  ),
                  // Add other arbiters from the list
                  ...arbiters.map((arbiter) {
                    return DropdownMenuItem<String>(
                      value: arbiter['arbi_id'].toString(),
                      child: Text(arbiter['name']),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedArbiter = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await editAccount(
                  account['acc_id'],
                  usernameController.text,
                  passwordController.text,
                  selectedArbiter == null ? null : selectedArbiter,
                );
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
