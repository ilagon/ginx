import 'package:flutter/material.dart';
import 'package:ginx/constants/palette.dart';
import 'package:ginx/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GINX | Google Indexing App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: primaryColor,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
