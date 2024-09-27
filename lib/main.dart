import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      // debugShowMaterialGrid: true, // Enable debug paint
    );
  }
}
