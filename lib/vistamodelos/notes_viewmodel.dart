import 'package:flutter/material.dart';
import '../modelos/nota.dart';
import '../db/notas_database.dart';

class NotesViewModel extends ChangeNotifier {
  List<Note> notes = [];

  Future<void> loadNotes() async {
    notes = await NotesDatabase.instance.readAllNotes();

    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await NotesDatabase.instance.insert(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await NotesDatabase.instance.update(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await NotesDatabase.instance.delete(id);
    await loadNotes();
  }

  Future<void> togglePin(Note note) async {
    final updatedNote = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await NotesDatabase.instance.update(updatedNote);
    await loadNotes();
  }
}
