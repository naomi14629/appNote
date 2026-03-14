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
      title: 'Notas Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotesListScreen(),
    );
  }
}
