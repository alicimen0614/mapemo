import 'package:e_commerce_ml/bottom_nav_bar_builder.dart';
import 'package:e_commerce_ml/firebase_options.dart';
import 'package:e_commerce_ml/screens/auth_screen/auth_screen.dart';
import 'package:e_commerce_ml/screens/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

AuthService _authService = AuthService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce With Machine Learning',
        theme: ThemeData(
            fontFamily: 'Nunito Sans',
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF124076),
            ),
            textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFFFBA834))),
            scaffoldBackgroundColor: Colors.white,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF124076)),
            primaryColor: const Color(0xFF124076),
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBA834)))),
        home: StreamBuilder(
            stream: _authService.authState,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return const BottomNavBarBuilder();
              } else {
                return const AuthScreen();
              }
            }));
  }
}
