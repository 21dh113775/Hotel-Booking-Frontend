import 'dart:convert';
import 'package:hotel_booking_frontend/features/auth/models/user.dart';
import 'package:http/http.dart' as http;
import '../../../services/api_client.dart';

class AuthService {
  Future<http.Response> register(Map<String, dynamic> data) async {
    final response = await ApiClient.post('/api/auth/register', data);
    print(
      'Register response: ${response.statusCode} ${response.body}',
    ); // Log để debug
    return response;
  }

  Future<http.Response> login(Map<String, dynamic> data) async {
    final response = await ApiClient.post('/api/auth/login', data);
    print(
      'Login response: ${response.statusCode} ${response.body}',
    ); // Log để debug
    return response;
  }

  Future<User> getProfile() async {
    final response = await ApiClient.get('/api/auth/profile');
    print(
      'Profile response: ${response.statusCode} ${response.body}',
    ); // Log để debug
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load profile: ${response.statusCode} ${response.body}',
      );
    }
  }
}
