import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nlrc_archive/screens/login_page.dart';
import 'package:nlrc_archive/sql_functions/load_server.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

List<Map<String, dynamic>> previousDocuments = [];
List<Map<String, dynamic>> documents = [];
List<Map<String, dynamic>> disposeDocuments = [];

List<dynamic> sackCreatedList = [];
List<dynamic> sackPendingList = [];
String query = '';
String disposeQuery = '';

List<dynamic> requestedDocument = [];
String serverIP = '';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAspectRatio(16 / 9);
    await windowManager.setAlignment(Alignment.center);
    await windowManager.setMinimumSize(Size(1421, 799.31));
    await windowManager.show();
  });
  serverIP = await loadServerIP();
  print(serverIP);
  runApp(const MyApp());
}

WindowOptions windowOptions = WindowOptions(
  minimumSize: Size(1421, 799.31),
  size: Size(1430, 804.38),
  title: 'NLRC Archive System',
);
/* 
Future<String> loadServerIP() async {
  try {
    Directory? documentsDir = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDir.path}\\config.json';

    File file = File(filePath);
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      Map<String, dynamic> config = jsonDecode(jsonString);
      return config["server_ip"] ?? '127.0.0.1';
    } else {
      print("Config file not found, using default localhost.");
      return '127.0.0.1';
    }
  } catch (e) {
    print("Error loading server IP: $e");
    return '127.0.0.1';
  }
} */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NLRC Archive',
      theme: ThemeData(
        fontFamily: 'readexPro',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IndexPage(),
    );
  }
}
