import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'screens/dashboard.dart';

void main() {
  Intl.defaultLocale = 'pt_BR';

  runApp(const LojaDeRoupasApp());
}

class LojaDeRoupasApp extends StatelessWidget {
  const LojaDeRoupasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja de Roupas',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),

      home: Dashboard(),
    );
  }
}