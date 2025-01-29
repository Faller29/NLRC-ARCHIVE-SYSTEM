import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> sendForApproval(String sackId) async {
  print(sackId);
  try {
    final response = await http.post(
      Uri.parse('http://localhost/nlrc_archive_api/send_sack.php'),
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

Future<List<Map<String, dynamic>>> fetchDocuments(String query) async {
  var url = "http://localhost/nlrc_archive_api/retrieve_data.php";

  final uri = Uri.parse(url).replace(queryParameters: {
    'Query': query,
  });

  try {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("document: $data");
      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'sack_id': int.tryParse(item['sack_id'].toString()) ?? 0,
            'sack_name': item['sack_name'] ?? '',
            'doc_id': int.tryParse(item['doc_id'].toString()) ?? 0,
            'doc_complainant': item['doc_complainant'] ?? '',
            'doc_respondent': item['doc_respondent'] ?? '',
            'doc_name': item['doc_number'] ?? '',
            'status': item['doc_status'] ?? '',
            'verdict': item['verdict'] ?? '',
            'version': item['version'] ?? '',
            'volume': item['volume'] ?? '',
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
  var url = "http://localhost/nlrc_archive_api/retrieve_created_sack.php";
  try {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("CSAC: $data");
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data');
  }
}

Future<List<dynamic>> fetchPendingSack() async {
  var url = "http://localhost/nlrc_archive_api/retrieve_pending_sack.php";
  try {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("PSACK: $data");
      return data;
    } else {
      throw Exception('Failed to fetch');
    }
  } catch (e) {
    throw Exception('Failed to fetch');
  }
}

Future<bool> requestRetrieval(var docId) async {
  try {
    String docIdStr = docId.toString();

    final response = await http.post(
      Uri.parse('http://localhost/nlrc_archive_api/request_document.php'),
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
