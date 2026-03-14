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
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Nueva Nota' : 'Editar Nota',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 24),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Eliminar nota',
                      style: TextStyle(
                        color: Color(0xFF6B4B6B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: const Text(
                      '¿Seguro que deseas eliminar esta nota? No se puede deshacer.',
                      style: TextStyle(color: Color(0xFF8B5A8E)),
                    ),
                    backgroundColor: const Color(0xFFFAF8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFF8B5A8E)),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A5D4),
                          foregroundColor: Colors.white,
                        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B4B6B),
                ),
                decoration: InputDecoration(
                  hintText: 'Título de la nota',
                  hintStyle: const TextStyle(
                    color: Color(0xFFD4A5D4),
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5A8E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.note == null
                    ? 'Nueva nota'
                    : 'Editada: ${widget.note!.updatedAt.toString().split('.')[0]}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB8A5B8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _contentController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B4B6B),
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText: 'Escribe tu nota aquí...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFD4A5D4),
                    fontSize: 16,
                  ),
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
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5A8E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 12,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final now = DateTime.now();

          if (_titleController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('El título no puede estar vacío'),
                backgroundColor: Color(0xFF8B5A8E),
              ),
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
        icon: const Icon(Icons.check),
        label: const Text('Guardar'),
      ),
    );
  }
}
