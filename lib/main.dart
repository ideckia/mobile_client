import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'view/LookForIpView.dart';

void main() {
  runApp(Ideckia());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class Ideckia extends StatelessWidget {
  // This widget is the root of your application.
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideckia',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade700,
        primarySwatch: Colors.blue,
      ),
      home: LookForIpView(),
    );
  }
}
