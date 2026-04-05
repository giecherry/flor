import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FlorApp());
}

class FlorApp extends StatelessWidget {
  const FlorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF9E4A0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
