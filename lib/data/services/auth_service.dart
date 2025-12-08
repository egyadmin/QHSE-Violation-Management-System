import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

/// Authentication Service for QHSE Cloud Backend
class AuthService {
  final ApiClient _apiClient;
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  AuthService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      developer.log('🔐 Attempting login: $email');
      
      // Use the correct login endpoint
      final response = await _apiClient.post(
        '/api/public/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      developer.log('✅ Login response: ${response.statusCode}');
      developer.log('   Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Check if login was successful
        if (data['success'] == true) {
          final user = data['user'] as Map<String, dynamic>?;
          
          if (user != null) {
            // Save user data (no token from this API)
            await _saveUser(user);
            
            // Save a simple flag to indicate logged in
            await _saveToken('logged_in');
            
            developer.log('✅ Login successful, user: ${user['email']}');
            return true;
          }
        } else {
          developer.log('❌ Login failed: ${data['message'] ?? data['messageEn']}');
        }
      }
      
      developer.log('❌ Login failed: Invalid credentials');
      return false;
    } catch (e, stackTrace) {
      developer.log('❌ Login error: $e');
      developer.log('   Stack: $stackTrace');
      return false;
    }
  }

  /// Auto-login using saved token
  Future<bool> autoLogin() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        developer.log('⚠️ No saved token found');
        return false;
      }
      
      developer.log('🔄 Auto-login with saved token');
      // Not needed for public API
      // _apiClient.setToken(token);
      
      // Verify token is still valid
      try {
        final response = await _apiClient.get('/auth/user');
        if (response.statusCode == 200) {
          developer.log('✅ Auto-login successful');
          return true;
        }
      } catch (e) {
        developer.log('⚠️ Token expired, clearing');
        await logout();
        return false;
      }
      
      return false;
    } catch (e) {
      developer.log('❌ Auto-login error: $e');
      return false;
    }
  }

  /// Logout and clear saved data
  Future<void> logout() async {
    try {
      developer.log('🚪 Logging out');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      
      // Not needed for public API
      // _apiClient.setToken(null);
      
      developer.log('✅ Logout successful');
    } catch (e) {
      developer.log('❌ Logout error: $e');
    }
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      // Return saved user data
      return await getSavedUser();
    } catch (e) {
      developer.log('❌ Get user error: $e');
      return null;
    }
  }

  /// Get saved token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Save user data
  Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  /// Get saved user data
  Future<Map<String, dynamic>?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return jsonDecode(userJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
