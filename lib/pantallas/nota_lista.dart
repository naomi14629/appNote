import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vistamodelos/notes_viewmodel.dart';
import '../modelos/nota.dart';
import 'nota_detalle.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotesViewModel>(context);

    // Filtrar notas según búsqueda
    final filteredNotes = viewModel.notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('No hay notas'))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          note.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            note.isPinned
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            color: note.isPinned ? Colors.orange : null,
                          ),
                          onPressed: () {
                            viewModel.togglePin(note);
                          },
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
          ),
        ],
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
