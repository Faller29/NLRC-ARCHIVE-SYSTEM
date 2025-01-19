import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nlrc_archive/widgets/login_widget.dart';

class IndexPage extends StatefulWidget {
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/pilipinas.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Color.fromARGB(255, 15, 11, 83).withValues(alpha: 0.5),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.asset(
              'assets/images/NLRC-WHITE.png',
              fit: BoxFit.contain,
              height: 100,
              width: 100,
            ),
          ),
        ),
        Center(
          child: LoginWidget(),
        ),
      ],
    ));
  }
}
