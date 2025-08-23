import 'dart:convert';
import 'package:hotel_booking_frontend/features/auth/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://localhost:7284';

  Future<http.Response> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  Future<User?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) throw Exception('No token available');

    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load profile: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
