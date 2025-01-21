import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nlrc_archive/modals/sack_content.dart';
import 'package:nlrc_archive/widgets/text_field_widget.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final today = DateFormat('EEEE, MMMM, dd, yyyy').format(DateTime.now());
  String nlrc = "National Labor Relations Commission";
  List<Map<String, String>> _users = [
    {'name': 'LA Santos', 'room': '1'},
    {'name': 'LA Renzy', 'room': '2'},
    {'name': 'LA Simon', 'room': '3'},
  ];

  List<Map<String, String>> _accounts = [
    {'username': 'arbiter1', 'password': 'password123', 'user': 'LA Renzy'},
    {'username': 'arbiter2', 'password': 'securepass', 'user': 'LA Simon'},
  ];

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
                    // Left Column
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
                                        _showAddUserDialog(
                                            context); // Show dialog for adding a user
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
                                    itemCount: _users.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.blueGrey[700],
                                            child: Text(
                                              _users[index]['name']![
                                                  0], // First letter of the name
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          title: Text(_users[index]['name']!),
                                          subtitle: Text(
                                              'Room: ${_users[index]['room']}'),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                _users.removeAt(
                                                    index); // Remove user
                                              });
                                            },
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
                                      'Accounts',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showAddAccountDialog(context);
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
                                    itemCount: _accounts.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.blueGrey[700],
                                            child: Text(
                                              _accounts[index]['username']![
                                                  0], // First letter of username
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          title: Text(
                                              'Username: ${_accounts[index]['username']}'),
                                          subtitle: Text(
                                            'Password: ${_accounts[index]['password']}\nArbiter: ${_accounts[index]['user']}',
                                          ),
                                          isThreeLine: true,
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                _accounts.removeAt(
                                                    index); // Remove account
                                              });
                                            },
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

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final roomController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    void addUser() {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          _users.add({
            'name': nameController.text,
            'room': roomController.text,
          });
        });
        Navigator.of(context).pop();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Arbiter'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldBoxWidget(
                  controller: nameController,
                  labelText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black),
              onPressed: () {
                addUser();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedUser;
    final _formKey = GlobalKey<FormState>();
    void addAccount() {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          _accounts.add({
            'username': usernameController.text,
            'password': passwordController.text,
            'user': selectedUser!,
          });
        });
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
                SizedBox(
                  height: 10,
                ),
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
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: selectedUser,
                  items: _users
                      .map((user) => DropdownMenuItem(
                            value: user['name'],
                            child: Text(user['name']!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedUser = value!;
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
              onPressed: () {
                addAccount();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
