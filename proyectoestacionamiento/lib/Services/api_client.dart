import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Core/api_config.dart';

class ApiClient {
  const ApiClient();

  Future<http.Response> get(String path) {
    return http.get(Uri.parse('${ApiConfig.baseUrl}$path'));
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) {
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
