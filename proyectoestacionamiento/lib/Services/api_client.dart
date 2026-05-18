import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Core/api_config.dart';

class ApiClient {
  const ApiClient();

  static const Duration _timeout = Duration(seconds: 25);

  Future<http.Response> get(String path) {
    return http.get(Uri.parse('${ApiConfig.baseUrl}$path')).timeout(_timeout);
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) {
    return http
        .post(
          Uri.parse('${ApiConfig.baseUrl}$path'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(_timeout);
  }
}
