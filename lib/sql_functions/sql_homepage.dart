import 'package:http/http.dart' as http;
import 'package:nlrc_archive/main.dart';
import 'dart:convert';

import 'package:nlrc_archive/screens/screen_wrapper.dart';

Future<Map<String, dynamic>> sendForApproval(String sackId) async {
  try {
    final response = await http.post(
      Uri.parse('http://$serverIP/nlrc_archive_api/send_sack.php'),
      body: {'sack_id': sackId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'status': 'error', 'message': 'Server error'};
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Failed to connect to the server'};
  }
}

Future<List<Map<String, dynamic>>> fetchDocuments(
    String query, String? user) async {
  var url = "http://$serverIP/nlrc_archive_api/retrieve_data.php";

  final uri = Uri.parse(url).replace(queryParameters: {
    'Query': query,
    'User': user ??
        '', // Pass user parameter (null will be sent as an empty string)
  });

  try {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'sack_id': int.tryParse(item['sack_id'].toString()) ?? 0,
            'sack_name': item['sack_name'] ?? '',
            'doc_id': int.tryParse(item['doc_id'].toString()) ?? 0,
            'doc_complainant': item['doc_complainant'] ?? '',
            'doc_respondent': item['doc_respondent'] ?? '',
            'doc_number': item['doc_number'] ?? '',
            'status': item['doc_status'] ?? '',
            'verdict': item['verdict'] ?? '',
            'version': item['version'] ?? '',
            'doc_volume': item['volume'] ?? '',
            'arbi_name': item['arbiter_number'] ?? '',
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

Future<List<dynamic>> fetchCreatedSack() async {
  var url = "http://$serverIP/nlrc_archive_api/retrieve_created_sack.php";

  final uri = Uri.parse(url).replace(queryParameters: {
    'acc_id': accountId,
  });

  try {
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data');
  }
}

Future<List<dynamic>> fetchPendingSack({String? user}) async {
  var url = "http://$serverIP/nlrc_archive_api/retrieve_pending_sack.php";

  if (user != null) {
    url += "?user=$user";
  }

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch');
    }
  } catch (e) {
    throw Exception('Failed to fetch');
  }
}

Future<bool> requestRetrieval(var docId, var accountId) async {
  try {
    String docIdStr = docId.toString();

    final response = await http.post(
      Uri.parse('http://$serverIP/nlrc_archive_api/request_document.php'),
      body: {'doc_id': docIdStr, "acc_id": accountId},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> disposeDocument(var docId) async {
  try {
    String docIdStr = docId.toString();

    final response = await http.post(
      Uri.parse('http://$serverIP/nlrc_archive_api/dispose_document.php'),
      body: {'doc_id': docIdStr},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> disposeSack(var sackId) async {
  try {
    String docIdStr = sackId.toString();

    final response = await http.post(
      Uri.parse('http://$serverIP/nlrc_archive_api/dispose_sack.php'),
      body: {'sack_id': docIdStr},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<List<Map<String, dynamic>>> fetchDisposedDocuments(
    String query, String? user) async {
  var url = "http://$serverIP/nlrc_archive_api/retrieve_disposed_data.php";

  final uri = Uri.parse(url).replace(queryParameters: {
    'Query': query,
    'User': user ??
        '', // Pass user parameter (null will be sent as an empty string)
  });

  try {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'sack_id': int.tryParse(item['sack_id'].toString()) ?? 0,
            'sack_name': item['sack_name'] ?? '',
            'doc_id': int.tryParse(item['doc_id'].toString()) ?? 0,
            'doc_complainant': item['doc_complainant'] ?? '',
            'doc_respondent': item['doc_respondent'] ?? '',
            'doc_number': item['doc_number'] ?? '',
            'status': item['doc_status'] ?? '',
            'verdict': item['verdict'] ?? '',
            'version': item['version'] ?? '',
            'doc_volume': item['volume'] ?? '',
            'arbi_name': item['arbiter_number'] ?? '',
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
