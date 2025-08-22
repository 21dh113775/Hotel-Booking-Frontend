import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotel_booking_frontend/features/auth/models/user.dart';
import '../../../services/api_client.dart';

class AuthService {
  Future<http.Response> register(Map<String, dynamic> data) async {
    final response = await ApiClient.post(
      '/api/auth/register',
      body: data,
      withAuth: false,
    );
    print('Register response: ${response.statusCode} ${response.body}');
    return response;
  }

  Future<http.Response> login(Map<String, dynamic> data) async {
    final response = await ApiClient.post(
      '/api/auth/login',
      body: data,
      withAuth: false,
    );
    print('Login response: ${response.statusCode} ${response.body}');
    return response;
  }

  Future<User> getProfile() async {
    final response = await ApiClient.get('/api/auth/profile');
    print('Profile response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      try {
        return User.fromJson(jsonDecode(response.body));
      } catch (e) {
        print('Parse user error: $e');
        throw Exception('Failed to parse user profile: $e');
      }
    } else {
      String errorMessage;
      try {
        final json = jsonDecode(response.body);
        errorMessage =
            json['message'] ?? 'Failed to load profile: ${response.statusCode}';
      } catch (e) {
        errorMessage = 'Server error: ${response.body}';
      }
      throw Exception(errorMessage);
    }
  }
}
