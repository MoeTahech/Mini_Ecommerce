import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  String? _token;

  ApiClient(String baseUrl)
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ));

  void setToken(String token) {
    _token = token;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _token = null;
    dio.options.headers.remove('Authorization');
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, dynamic body) async {
    return await dio.post(path, data: body);
  }
}
