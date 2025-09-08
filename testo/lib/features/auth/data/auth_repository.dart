import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class AuthRepository {
  static final Map<String, String> _mockUsers = {
    "admin@test.com": "admin123",
    "user@test.com": "1234",
  };

  final _random = Random();

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    // Simulate transient network error randomly
    if (_random.nextInt(10) < 2) throw Exception("Network error");

    if (_mockUsers[email] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", "mock-token-123");
      return true;
    }

    return false;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_mockUsers.containsKey(email)) return false; // already exists
    _mockUsers[email] = password;
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Simulate 401 token expiry
  Future<void> simulate401() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token"); // invalidate token
  }
}
