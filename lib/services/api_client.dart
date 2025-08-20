import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_config.dart'; // Sẽ tạo ở bước sau

class ApiClient {
  static Future<Map<String, String>> getHeaders({bool withAuth = true}) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return http.get(uri, headers: headers);
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return http.post(uri, headers: headers, body: jsonEncode(body));
  }

  // Thêm put, delete nếu cần sau
}
