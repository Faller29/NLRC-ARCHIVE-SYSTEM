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
      print("Fetched documents: $data");

      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'sack_id': int.tryParse(item['sack_id'].toString()) ?? 0,
            'sack_name': item['sack_name'] ?? '',
            'doc_id': int.tryParse(item['doc_id'].toString()) ?? 0,
            'doc_title': item['doc_title'] ?? '',
            'status': item['doc_status'] ?? '',
            'verdict': item['verdict'] ?? '',
          };
        }),
      );
    } else {
      throw Exception('Failed to load documents');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to load documents');
  }
}
