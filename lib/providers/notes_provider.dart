import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  bool _showArchived = false;
  String _searchQuery = '';

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  bool get showArchived => _showArchived;
  String get searchQuery => _searchQuery;

  List<Note> get filteredNotes {
    return _notes.where((note) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final titleMatch = note.title.toLowerCase().contains(query);
      final contentMatch = note.content.toLowerCase().contains(query);
      final tagMatch = note.tags.any((t) => t.toLowerCase().contains(query));
      return titleMatch || contentMatch || tagMatch;
    }).toList();
  }

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await StorageService.getNotes(isArchived: _showArchived);
    _isLoading = false;
    notifyListeners();
  }

  void setArchivedTab(bool archived) {
    if (_showArchived != archived) {
      _showArchived = archived;
      fetchNotes();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> createNote(String title, String content, List<String> tags) async {
    await StorageService.createNote(title, content, tags);
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await StorageService.updateNote(note);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await StorageService.deleteNote(id);
    await fetchNotes();
  }

  Future<void> toggleArchive(Note note) async {
    final updated = note.copyWith(isArchived: !note.isArchived);
    await StorageService.updateNote(updated);
    await fetchNotes();
  }
}
