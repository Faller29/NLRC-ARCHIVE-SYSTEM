import 'package:flutter/material.dart';
import 'package:nlrc_archive/screens/login_page.dart';
import 'package:nlrc_archive/sql_functions/sql_homepage.dart';
import 'package:window_manager/window_manager.dart';

List<Map<String, dynamic>> previousDocuments = [];
List<Map<String, dynamic>> documents = [];
List<dynamic> sackCreatedList = [];
List<dynamic> sackPendingList = [];
String query = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAspectRatio(16 / 9);
    await windowManager.setAlignment(Alignment.center);
    await windowManager.setMinimumSize(Size(1421, 799.31));
    await windowManager.show();
  });

  runApp(const MyApp());
}

WindowOptions windowOptions = WindowOptions(
  minimumSize: Size(1421, 799.31),
  size: Size(1430, 804.38),
  title: 'NLRC Archive System',
);

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
