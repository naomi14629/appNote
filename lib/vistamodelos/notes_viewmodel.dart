import 'package:flutter/material.dart';
import '../modelos/nota.dart';
import '../db/notas_database.dart';

class NotesViewModel extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await NotesDatabase.instance.readAllNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    final newNote = await NotesDatabase.instance.create(note);
    _notes.insert(0, newNote); // agrega al inicio
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await NotesDatabase.instance.update(note);
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  Future<void> deleteNote(int id) async {
    await NotesDatabase.instance.delete(id);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
