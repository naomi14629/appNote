import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vistamodelos/notes_viewmodel.dart';
import '../modelos/nota.dart';
import 'nota_detalle.dart';

class NotesListScreen extends StatelessWidget {
  // 👈 nombre exacto
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotesViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas')),
      body: viewModel.notes.isEmpty
          ? const Center(child: Text('No hay notas aún'))
          : ListView.builder(
              itemCount: viewModel.notes.length,
              itemBuilder: (context, index) {
                final note = viewModel.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteDetailScreen(note: note),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteDetailScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
