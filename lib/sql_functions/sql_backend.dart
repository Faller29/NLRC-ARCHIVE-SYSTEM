import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> addArbiter(
    String name, String room, String username, String password) async {
  final url = 'http://localhost/nlrc_archive_api/add_arbiter.php';

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'room': room,
        'username': username,
        'password': password,
      },
    );

    final responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      print('Arbiter added successfully!');
    } else {
      print('Error: ${responseData['message']}');
    }
  } catch (error) {
    print('Failed to add arbiter: $error');
  }
}

Future<List<Map<String, String>>> getArbiters() async {
  final url = 'http://localhost/nlrc_archive_api/get_arbiter.php';

  try {
    final response = await http.get(Uri.parse(url));

    final responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      List<Map<String, String>> arbiters = [];
      for (var arbiter in responseData['arbiters']) {
        arbiters.add({
          'arbi_id': arbiter['arbi_id'],
          'name': arbiter['arbi_name'],
          'room': arbiter['room'],
          'username': arbiter['username'],
          'password': arbiter['password'],
        });
      }
      return arbiters;
    } else {
      throw Exception('No arbiters found');
    }
  } catch (error) {
    print('Failed to fetch arbiters: $error');
    return [];
  }
}

Future<void> deleteUserAccount(String userId) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost/nlrc_archive_api/delete_user.php'),
      body: {'user_id': userId},
    );

    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      print('User account deleted successfully');
    } else {
      print('Error: ${data['message']}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<void> deleteArbiter(String arbiId) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost/nlrc_archive_api/delete_arbiter.php'),
      body: {'arbi_id': arbiId},
    );

    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      print('Arbiter and associated user account(s) deleted successfully');
    } else {
      print('Error: ${data['message']}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<void> updateArbiter(String arbiId, String name, String room,
    String username, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost/nlrc_archive_api/update_arbiter_account.php'),
    body: {
      'arbi_id': arbiId,
      'name': name,
      'room': room,
      'username': username,
      'password': password,
    },
  );

  final responseData = jsonDecode(response.body);

  if (responseData['status'] == 'success') {
  } else {
    // Failed to update
  }
}

//dump codes for adding and deleting user
/* 
Future<void> addUser(String username, String password, String arbiter) async {
  final url = 'http://localhost/nlrc_archive_api/add_users.php';

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
        'arbi_id': arbiter,
      },
    );

    final responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      print('Arbiter added successfully!');
    } else {
      print('Error: ${responseData['message']}');
    }
  } catch (error) {
    print('Failed to add arbiter: $error');
  }
}

Future<List<Map<String, String>>> getUser() async {
  final url = 'http://localhost/nlrc_archive_api/get_users.php';

  try {
    final response = await http.get(Uri.parse(url));

    final responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      List<Map<String, String>> arbiters = [];
      for (var arbiter in responseData['arbiters']) {
        arbiters.add({
          'username': arbiter['username'],
          'password': arbiter['password'],
          'name': arbiter['arbi_name'],
          'user_id': arbiter['acc_id'],
        });
      }
      return arbiters;
    } else {
      throw Exception('No arbiters found');
    }
  } catch (error) {
    print('Failed to fetch arbiters: $error');
    return [];
  }
} */
