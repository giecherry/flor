import 'package:flutter/material.dart';

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
          seedColor: const Color(0xFFF9E4A0), // soft yellow
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFAF5),
        elevation: 0,
        title: const Text(
          'Flor',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: const Center(child: Text('Your garden lives here 🌸')),
    );
  }
}
