import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<String> loadServerIP() async {
  try {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDir.path}\\config.json';

    File file = File(filePath);
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      Map<String, dynamic> config = jsonDecode(jsonString);

      List<dynamic> ipList = config["server_ips"] ?? ["127.0.0.1"];

      // Test each IP
      for (String ip in ipList) {
        if (await testConnection(ip)) {
          print("Connected to: $ip");
          return ip;
        }
      }
    } else {
      print("Config file not found, using default 127.0.0.1.");
    }
  } catch (e) {
    print("Error loading server IP: $e");
  }

  print("No working server IP found!");
  return "0";
}

Future<bool> testConnection(String ip) async {
  try {
    final response = await http
        .get(Uri.parse('http://$ip/nlrc_archive_api/test.php'))
        .timeout(Duration(seconds: 3));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
