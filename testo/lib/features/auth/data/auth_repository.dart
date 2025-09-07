import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  // Mock users database
  final Map<String, String> _mockUsers = {
    "test@test.com": "1234", // email: password
  };

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
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
}
