import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://localhost:7284';

  // === GIẢI THÍCH: Phương thức getHeaders để lấy headers với auth ===
  // Lý do sửa: Làm public để gọi từ service, bổ sung logging nếu token null để debug 401 Unauthorized khi test ===
  static Future<Map<String, String>> getHeaders({bool withAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      print(
        'ApiClient token: $token',
      ); // Logging để test token có tồn tại không
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        print(
          'Cảnh báo: Không tìm thấy token - Request có thể bị 401. Kiểm tra login.',
        );
      }
    }
    print('Headers đầy đủ: $headers');
    return headers;
  }

  static Future<http.Response> get(
    String endpoint, {
    bool withAuth = true,
  }) async {
    final headers = await getHeaders(withAuth: withAuth);
    print('GET request: $baseUrl$endpoint, Headers: $headers');
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    print('GET response: ${response.statusCode}');
    if (response.statusCode != 200) {
      print(
        'GET error body: ${response.body}',
      ); // Logging body nếu lỗi để test dễ hơn
    }
    return response;
  }

  static Future<http.Response> post(
    String endpoint, {
    dynamic body,
    bool withAuth = true,
  }) async {
    final headers = await getHeaders(withAuth: withAuth);
    print('POST request: $baseUrl$endpoint, Body: $body, Headers: $headers');
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    print('POST response: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('POST error body: ${response.body}');
    }
    return response;
  }

  static Future<http.Response> put(
    String endpoint, {
    dynamic body,
    bool withAuth = true,
  }) async {
    final headers = await getHeaders(withAuth: withAuth);
    print('PUT request: $baseUrl$endpoint, Body: $body, Headers: $headers');
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    print('PUT response: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('PUT error body: ${response.body}');
    }
    return response;
  }

  static Future<http.Response> delete(
    String endpoint, {
    bool withAuth = true,
  }) async {
    final headers = await getHeaders(withAuth: withAuth);
    print('DELETE request: $baseUrl$endpoint, Headers: $headers');
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    print('DELETE response: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('DELETE error body: ${response.body}');
    }
    return response;
  }
}
