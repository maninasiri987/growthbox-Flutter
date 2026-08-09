import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await StorageService.getToken();
      final isLocal = await StorageService.isLocalMode();
      if (token != null || isLocal) {
        _user = await ApiService.getMe() ?? await StorageService.getUser();
      }
    } catch (_) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithLocalStorage() async {
    _isLoading = true;
    notifyListeners();
    await StorageService.setAuthMode('local');
    await StorageService.setToken('local-token');
    _user = await StorageService.getUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await StorageService.clearToken();
    _user = null;
    notifyListeners();
  }
}
