import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/nota.dart';
import '../vistamodelos/notes_viewmodel.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar eliminación'),
                    content: const Text(
                      '¿Seguro que quieres eliminar esta nota?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  viewModel.deleteNote(widget.note!.id!);
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Contenido'),
              maxLines: 8,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          final now = DateTime.now();

          if (_titleController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('El título no puede estar vacío')),
            );
            return;
          }

          if (widget.note == null) {
            final newNote = Note(
              title: _titleController.text,
              content: _contentController.text,
              createdAt: now,
              updatedAt: now,
            );
            viewModel.addNote(newNote);
          } else {
            final updatedNote = widget.note!.copyWith(
              title: _titleController.text,
              content: _contentController.text,
              updatedAt: now,
            );
            viewModel.updateNote(updatedNote);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
