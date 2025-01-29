import 'package:flutter/material.dart';

Color primaryRed = Color.fromARGB(255, 214, 30, 17);
Color primaryBlue = Color.fromARGB(255, 60, 17, 214);
Color primaryWhite = Color.fromARGB(255, 247, 236, 236);
Color primaryBlack = Color.fromARGB(255, 0, 0, 0);
TextStyle titleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);
TextStyle txtBttWhite = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
TextStyle txtBttBlack = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

SnackBar snackBarFailed(String text, BuildContext context) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width / 3, vertical: 10),
    backgroundColor: Colors.redAccent,
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}

SnackBar snackBarSuccess(String text, BuildContext context) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width / 3, vertical: 10),
    backgroundColor: Colors.greenAccent,
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    duration: Duration(seconds: 3),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
