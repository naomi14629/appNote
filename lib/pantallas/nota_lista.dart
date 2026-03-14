import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vistamodelos/notes_viewmodel.dart';
import '../modelos/nota.dart';

class NotesListScreen extends StatelessWidget {
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
                    // Aquí luego abriremos la pantalla de detalle
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final nuevaNota = Note(
            title: 'Nueva nota',
            content: 'Contenido vacío',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          viewModel.addNote(nuevaNota);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
