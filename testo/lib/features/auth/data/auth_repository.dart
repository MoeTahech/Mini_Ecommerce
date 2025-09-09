import 'package:dio/dio.dart';
import '../../../core/api_client.dart';

class AuthRepository {
  final ApiClient api;

  AuthRepository(this.api);

  Future<String?> login(String email, String password) async {
    try {
      final resp = await api.post('/auth/login', {
        'email': email,
        'password': password,
      });
      if (resp.statusCode == 200) {
        final token = resp.data['token'] as String;
        api.setToken(token); // Save token in ApiClient
        return token;
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Login failed';
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final resp = await api.post('/auth/register', {
        'email': email,
        'password': password,
      });
      return resp.statusCode == 201;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Register failed';
    }
  }
}
