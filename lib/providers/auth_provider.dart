import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';

/// Authentication Provider
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Check authentication status on app start
  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn) {
        final success = await _authService.autoLogin();
        if (success) {
          final userData = await _authService.getCurrentUser();
          if (userData != null) {
            _currentUser = User.fromJson(userData);
            _isAuthenticated = true;
          }
        }
      }
    } catch (e) {
      print('Check auth status error: $e');
      _currentUser = null;
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _isAuthenticated;
  }

  /// Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.login(email, password);
      
      if (success) {
        final userData = await _authService.getCurrentUser();
        if (userData != null) {
          _currentUser = User.fromJson(userData);
          _isAuthenticated = true;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete Account
  Future<bool> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.deleteAccount();
      if (success) {
        _currentUser = null;
        _isAuthenticated = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Delete account error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
