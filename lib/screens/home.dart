import 'package:flutter/material.dart';
import 'package:ginx/constants/palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to the Home Screen',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
