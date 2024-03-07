import 'package:e_commerce_ml/screens/auth_screen/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce With Machine Learning',
      theme: ThemeData(
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Color(0xFFFBA834))),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF124076)),
          primaryColor: const Color(0xFF124076),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBA834)))),
      home: const AuthScreen(),
    );
  }
}
