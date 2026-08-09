import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/storage_service.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;
  int _filterIndex = 0; // 0 = All, 1 = Active, 2 = Completed

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  int get filterIndex => _filterIndex;

  List<Todo> get filteredTodos {
    if (_filterIndex == 1) {
      return _todos.where((t) => !t.isCompleted).toList();
    } else if (_filterIndex == 2) {
      return _todos.where((t) => t.isCompleted).toList();
    }
    return _todos;
  }

  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();
    _todos = await StorageService.getTodos();
    _isLoading = false;
    notifyListeners();
  }

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  Future<void> createTodo(String title, String description, int priority) async {
    await StorageService.createTodo(title, description, priority);
    await fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await StorageService.updateTodo(todo);
    await fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await StorageService.deleteTodo(id);
    await fetchTodos();
  }

  Future<void> toggleCompleted(Todo todo) async {
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    await StorageService.updateTodo(updated);
    await fetchTodos();
  }
}
