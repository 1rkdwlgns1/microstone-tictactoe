import 'package:flutter/material.dart';
import 'pages/main_page.dart'; // ✅ main_page.dart 연결

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Microstone TicTacToe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CuteFont',
      ),
      home: const MainPage(), // ✅ 시작 페이지를 MainPage로
    );
  }
}
