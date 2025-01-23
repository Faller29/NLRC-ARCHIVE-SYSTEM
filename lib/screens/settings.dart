import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/main.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/screens/screen_wrapper.dart';
import 'package:nlrc_archive/sql_functions/sql_backend.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";

  Future<void> fetchArbiters() async {
    List<Map<String, String>> arbiters = await getArbiters();
    setState(() {
      arbiter = arbiters;
    });
  }

  void _addNewArbiter(
      String name, String room, String username, String password) {
    addArbiter(name, room, username, password).then((_) {
      fetchArbiters();
    });
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Arbiters',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showAddUserDialog(context);
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text('Add'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent,
                                        foregroundColor: Colors.black,
                                        iconColor: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: arbiter.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.blueGrey[700],
                                            child: Text(
                                              arbiter[index]['name']![0],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          title: Text(arbiter[index]['name']!),
                                          subtitle: Text(
                                              'Room: ${arbiter[index]['room']}'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  _showAddUserDialog(context,
                                                      isEdit: true,
                                                      user: arbiter[index]);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  String account_id =
                                                      arbiter[index]
                                                          ['arbi_id']!;
                                                  _showDeleteConfirmation(
                                                    context,
                                                    account_id,
                                                    () => deleteArbiter(
                                                            account_id)
                                                        .then((_) {
                                                      fetchArbiters();
                                                    }),
                                                  );
                                                },
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _showAddUserDialog(BuildContext context,
      {bool isEdit = false, Map<String, String>? user}) {
    final nameController =
        TextEditingController(text: isEdit && user != null ? user['name'] : '');
    final roomController =
        TextEditingController(text: isEdit && user != null ? user['room'] : '');
    final usernameController = TextEditingController(
        text: isEdit && user != null ? user['username'] : '');
    final passwordController = TextEditingController(
        text: isEdit && user != null ? user['password'] : '');
    final passwordConfirmController = TextEditingController(
        text: isEdit && user != null ? user['password'] : '');

    final _formKey = GlobalKey<FormState>();

    void submitUser() {
      if (_formKey.currentState?.validate() ?? false) {
        if (isEdit) {
          updateArbiter(
              user!['arbi_id']!,
              nameController.text,
              roomController.text,
              usernameController.text,
              passwordController.text);
        } else {
          _addNewArbiter(nameController.text, roomController.text,
              usernameController.text, passwordController.text);
        }
        Navigator.of(context).pop();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Arbiter' : 'Add Arbiter'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldBoxWidget(
                  controller: nameController,
                  labelText: 'Arbiter Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFieldBoxWidget(
                  controller: roomController,
                  labelText: 'Room Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Room Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFieldBoxWidget(
                  controller: usernameController,
                  labelText: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFieldBoxWidget(
                  controller: passwordController,
                  labelText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextFieldBoxWidget(
                  controller: passwordConfirmController,
                  labelText: 'Confirm Password',
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        passwordConfirmController.text !=
                            passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 10),
              ],
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
              onPressed: submitUser,
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }
/* 
  void _showAddAccountDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final roomController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String? _selectedArbiter;
    // Add the account (user) by calling the addUser function
    void addAccount() async {
      if (_formKey.currentState?.validate() ?? false) {
        // Call the addUser function with the appropriate parameters
        _addNewUser(
          usernameController.text,
          passwordController.text,
          _selectedArbiter!,
        );

        // If the user is successfully added, you can then close the dialog
        Navigator.of(context).pop();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Account'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name Field (for arbiter's name)
                TextFieldBoxWidget(
                  controller: nameController,
                  labelText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Room Field (for room number)
                TextFieldBoxWidget(
                  controller: roomController,
                  labelText: 'Room Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a room number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Username Field
                TextFieldBoxWidget(
                  controller: usernameController,
                  labelText: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Password Field
                TextFieldBoxWidget(
                  controller: passwordController,
                  labelText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 10),

                // Dropdown for selecting a user type (if needed)
                DropdownButtonFormField<String>(
                  value: _selectedArbiter,
                  items: arbiter
                      .map((user) => DropdownMenuItem(
                            value: user['arbi_id'],
                            child: Text(user['name']!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _selectedArbiter = value!;
                  },
                  decoration: InputDecoration(
                      labelText: 'User', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black),
              onPressed: addAccount, // Call the addAccount method
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  } */

  void _showDeleteConfirmation(
      BuildContext context, String id, VoidCallback onDelete) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete this item? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onDelete();

                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
