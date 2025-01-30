import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nlrc_archive/data/themeData.dart';

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

Future<List<Map<String, dynamic>>> fetchRequestedDocuments() async {
  var url = "http://localhost/nlrc_archive_api/fetch_request.php";

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'doc_id': item['doc_id'] ?? 0,
            'sack_id': item['sack_id'] ?? 0,
            'sack_name': item['sack_name'] ?? '',
            'arbiter_number': item['arbiter_number'] ?? '',
            'doc_number': item['doc_number'] ?? '',
            'doc_complainant': item['doc_complainant'] ?? '',
            'doc_respondent': item['doc_respondent'] ?? '',
            'verdict': item['verdict'] ?? '',
            'status': item['doc_status'] ?? '',
            'version': item['version'] ?? '',
            'volume': item['volume'] ?? '',
            'timestamp': item['timestamp'] ?? '',
            'arbi_name': item['arbi_name'] ?? '',
          };
        }),
      );
    } else {
      throw Exception('Failed to load documents');
    }
  } catch (e) {
    throw Exception('Failed to load documents');
  }
}

Future<List<Map<String, dynamic>>> fetchRetrievedDocuments() async {
  var url = "http://localhost/nlrc_archive_api/fetch_retrieved_document.php";

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'doc_id': item['doc_id'] ?? 0,
            'sack_id': item['sack_id'] ?? 0,
            'sack_name': item['sack_name'] ?? '',
            'arbiter_number': item['arbiter_number'] ?? '',
            'doc_number': item['doc_number'] ?? '',
            'doc_complainant': item['doc_complainant'] ?? '',
            'doc_respondent': item['doc_respondent'] ?? '',
            'verdict': item['verdict'] ?? '',
            'status': item['doc_status'] ?? '',
            'version': item['version'] ?? '',
            'volume': item['volume'] ?? '',
            'timestamp': item['timestamp'] ?? '',
            'arbi_name': item['arbi_name'] ?? '',
          };
        }),
      );
    } else {
      throw Exception('Failed to load documents');
    }
  } catch (e) {
    throw Exception('Failed to load documents');
  }
}

Future<void> updateDocumentStatus(var docId, String newStatus) async {
  docId = int.parse(docId);
  var url = "http://localhost/nlrc_archive_api/approve_request.php";

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "doc_id": docId,
        "new_status": newStatus,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == true) {
        print("Document status updated successfully");
      } else {
        print("Error updating status: ${data['error']}");
      }
    } else {
      print("Failed to connect to server");
    }
  } catch (e) {
    print("Exception: $e");
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
