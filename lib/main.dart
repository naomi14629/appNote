import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vistamodelos/notes_viewmodel.dart';
import 'pantallas/nota_lista.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesViewModel()..loadNotes(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppNota',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF8B5A8E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5A8E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B5A8E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD4A5D4),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0D5E8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0D5E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B5A8E), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF6B4B6B)),
        ),
      ),
      home: const NotesListScreen(),
    );
  }
}
