import 'package:flutter/material.dart';

import 'homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor:const Color(0XFF00061a),
        shadowColor: const Color(0XFF001456),
        splashColor: const Color(0XFF4169e8),
      ),
      home:  const HomePage(),
    );
  }
}

