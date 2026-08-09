import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import '../models/todo_model.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _authModeKey = 'auth_mode';
  static const String _tokenKey = 'token';
  static const String _userKey = 'local_user';
  static const String _notesKey = 'local_notes';
  static const String _todosKey = 'local_todos';
  static const String _themeKey = 'theme';

  static Future<bool> isLocalMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authModeKey) == 'local';
  }

  static Future<void> setAuthMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authModeKey, mode);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_authModeKey);
  }

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return User.fromJson(jsonDecode(userJson));
      } catch (_) {}
    }
    final defaultUser = User.defaultLocalUser;
    await setUser(defaultUser);
    return defaultUser;
  }

  static Future<void> setUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Theme preferences
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) != 'light';
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, isDark ? 'dark' : 'light');
  }

  // Notes Local Storage CRUD
  static Future<List<Note>> getNotes({bool? isArchived}) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString(_notesKey);
    List<Note> notes = [];
    if (notesJson != null) {
      try {
        final List<dynamic> list = jsonDecode(notesJson);
        notes = list.map((e) => Note.fromJson(e)).toList();
      } catch (_) {}
    } else {
      // Seed initial welcoming sample notes if empty
      notes = _getSeedNotes();
      await saveNotes(notes);
    }
    if (isArchived != null) {
      notes = notes.where((n) => n.isArchived == isArchived).toList();
    }
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final list = notes.map((e) => e.toJson()).toList();
    await prefs.setString(_notesKey, jsonEncode(list));
  }

  static Future<Note> createNote(String title, String content, List<String> tags) async {
    final notes = await getNotes();
    final newId = notes.isNotEmpty ? notes.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1 : 1;
    final now = DateTime.now();
    final newNote = Note(
      id: newId,
      title: title,
      content: content,
      tags: tags,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    );
    notes.add(newNote);
    await saveNotes(notes);
    return newNote;
  }

  static Future<Note?> updateNote(Note note) async {
    final notes = await getNotes();
    final idx = notes.indexWhere((e) => e.id == note.id);
    if (idx != -1) {
      final updated = note.copyWith(updatedAt: DateTime.now());
      notes[idx] = updated;
      await saveNotes(notes);
      return updated;
    }
    return null;
  }

  static Future<void> deleteNote(int id) async {
    final notes = await getNotes();
    notes.removeWhere((e) => e.id == id);
    await saveNotes(notes);
  }

  // Todos Local Storage CRUD
  static Future<List<Todo>> getTodos({bool? isCompleted}) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString(_todosKey);
    List<Todo> todos = [];
    if (todosJson != null) {
      try {
        final List<dynamic> list = jsonDecode(todosJson);
        todos = list.map((e) => Todo.fromJson(e)).toList();
      } catch (_) {}
    } else {
      todos = _getSeedTodos();
      await saveTodos(todos);
    }
    if (isCompleted != null) {
      todos = todos.where((t) => t.isCompleted == isCompleted).toList();
    }
    todos.sort((a, b) => b.priority.compareTo(a.priority));
    return todos;
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final list = todos.map((e) => e.toJson()).toList();
    await prefs.setString(_todosKey, jsonEncode(list));
  }

  static Future<Todo> createTodo(String title, String description, int priority) async {
    final todos = await getTodos();
    final newId = todos.isNotEmpty ? todos.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1 : 1;
    final now = DateTime.now();
    final newTodo = Todo(
      id: newId,
      title: title,
      description: description,
      isCompleted: false,
      priority: priority,
      createdAt: now,
      updatedAt: now,
    );
    todos.add(newTodo);
    await saveTodos(todos);
    return newTodo;
  }

  static Future<Todo?> updateTodo(Todo todo) async {
    final todos = await getTodos();
    final idx = todos.indexWhere((e) => e.id == todo.id);
    if (idx != -1) {
      final updated = todo.copyWith(updatedAt: DateTime.now());
      todos[idx] = updated;
      await saveTodos(todos);
      return updated;
    }
    return null;
  }

  static Future<void> deleteTodo(int id) async {
    final todos = await getTodos();
    todos.removeWhere((e) => e.id == id);
    await saveTodos(todos);
  }

  static List<Note> _getSeedNotes() {
    final now = DateTime.now();
    return [
      Note(
        id: 1,
        title: 'Welcome to growthBox Android!',
        content: 'Your notes and todos management powered by AI. Experience simple, fast, and intelligent productivity anywhere on your Android device.',
        tags: ['Welcome', 'Flutter', 'AI'],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),
      Note(
        id: 2,
        title: 'Project Goals & Growth Strategy',
        content: '1. Build consistent daily habits.\n2. Organize ideas into structured notes.\n3. Keep track of high-priority todos effortlessly.',
        tags: ['Growth', 'Goals'],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }

  static List<Todo> _getSeedTodos() {
    final now = DateTime.now();
    return [
      Todo(
        id: 1,
        title: 'Test growthBox Flutter APK',
        description: 'Check out local storage login and offline data persistence.',
        priority: 3,
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Todo(
        id: 2,
        title: 'Customize theme & organize notes',
        description: 'Try switching between Dark mode and Light mode in the top bar.',
        priority: 2,
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Todo(
        id: 3,
        title: 'Review productivity charts on Dashboard',
        description: 'Track daily progress and completed tasks.',
        priority: 1,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
