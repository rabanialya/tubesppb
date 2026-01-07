import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ApiClient {
  static Future<Map<String, String>> _getHeaders({
    bool needsAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth) {
      final token = await TokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Future<http.Response> get(
    String endpoint, {
    bool needsAuth = false,
  }) async {
    final headers = await _getHeaders(needsAuth: needsAuth);
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return http.get(uri, headers: headers);
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool needsAuth = false,
  }) async {
    final headers = await _getHeaders(needsAuth: needsAuth);
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needsAuth = false,
  }) async {
    final headers = await _getHeaders(needsAuth: needsAuth);
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return http.patch(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// ✅ DELETE (INI YANG KEMARIN BIKIN ERROR)
  static Future<http.Response> delete(
    String endpoint, {
    bool needsAuth = false,
  }) async {
    final headers = await _getHeaders(needsAuth: needsAuth);
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return http.delete(uri, headers: headers);
  }
}
