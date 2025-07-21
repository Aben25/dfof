import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulseforge/models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Simple validation for demo
    if (email.isNotEmpty && password.isNotEmpty) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: _extractNameFromEmail(email),
        createdAt: DateTime.now(),
      );
      
      await _saveUser(user);
      await _setLoggedIn(true);
      return true;
    }
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await _saveUser(user);
      await _setLoggedIn(true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final user = await getCurrentUser();
    if (user != null) {
      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: user.name,
        createdAt: user.createdAt,
        profile: profile,
      );
      await _saveUser(updatedUser);
    }
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  String _extractNameFromEmail(String email) {
    final parts = email.split('@');
    if (parts.isNotEmpty) {
      return parts.first.split('.').map((part) => 
        part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)
      ).join(' ');
    }
    return 'User';
  }
}