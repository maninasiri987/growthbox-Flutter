import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note_model.dart';
import '../models/todo_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://maniweb.pythonanywhere.com/api';

  static Future<Map<String, String>> _headers() async {
    final token = await StorageService.getToken();
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token != 'local-token') {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<User?> getMe() async {
    final isLocal = await StorageService.isLocalMode();
    if (isLocal) {
      return await StorageService.getUser();
    }
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) {
        return User.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }

  static Future<List<Note>> getNotes({bool isArchived = false}) async {
    final isLocal = await StorageService.isLocalMode();
    if (isLocal) {
      return await StorageService.getNotes(isArchived: isArchived);
    }
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/notes?archived=$isArchived'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => Note.fromJson(e)).toList();
      }
    } catch (_) {}
    return await StorageService.getNotes(isArchived: isArchived);
  }

  static Future<List<Todo>> getTodos({bool? isCompleted}) async {
    final isLocal = await StorageService.isLocalMode();
    if (isLocal) {
      return await StorageService.getTodos(isCompleted: isCompleted);
    }
    try {
      final query = isCompleted != null ? '?completed=$isCompleted' : '';
      final res = await http.get(
        Uri.parse('$baseUrl/todos$query'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => Todo.fromJson(e)).toList();
      }
    } catch (_) {}
    return await StorageService.getTodos(isCompleted: isCompleted);
  }
}
