import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/register_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  User? _user;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;

  final AuthService _authService = AuthService();

  AuthProvider() {
    loadToken();
  }

  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('SharedPreferences cleared');
  }

  Future<void> loadToken() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    print('Loaded token: $_token');

    if (_token != null && _token!.isNotEmpty) {
      try {
        if (!_isValidJwtFormat(_token!)) {
          print('Invalid JWT format, clearing token');
          await logout();
          _isLoading = false;
          notifyListeners();
          return;
        }

        final payload = _decodeJwtPayload(_token!);
        print('JWT payload: $payload');
        if (payload?['role'] != 'Admin') {
          print('Role is not Admin, clearing token');
          await logout();
          _isLoading = false;
          notifyListeners();
          throw Exception('Role not authorized as Admin');
        }

        _user = await _authService.getProfile();
        _isLoggedIn = true;
        print('User loaded: ${_user?.toJson()}');
      } catch (e) {
        print('Load token error: $e');
        await logout();
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  bool _isValidJwtFormat(String token) {
    final parts = token.split('.');
    return parts.length == 3;
  }

  Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded);
    } catch (e) {
      print('JWT decode error: $e');
      return null;
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required int roleId, // Tham số roleId
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final dto = RegisterDto(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        roleId: roleId, // Gửi RoleId = 1 cho Admin
      );
      print('Register request body: ${jsonEncode(dto.toJson())}'); // Debug body
      final response = await _authService.register(dto.toJson());
      print('Register response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        _token = json['token'];

        if (_token == null || _token!.isEmpty) {
          throw Exception('Token not found in response');
        }

        final payload = _decodeJwtPayload(_token!);
        print('JWT payload: $payload');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        print('New token saved: $_token');

        await Future.delayed(const Duration(milliseconds: 100));

        _user = await _authService.getProfile();
        _isLoggedIn = true;
      } else {
        String errorMessage;
        try {
          final json = jsonDecode(response.body);
          errorMessage =
              json['message'] ?? 'Register failed: ${response.statusCode}';
        } catch (e) {
          errorMessage = 'Server error: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Register error: $e');
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await clearSharedPreferences();

      final response = await _authService.login({
        'email': email,
        'password': password,
      });
      print('Login response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _token = json['token'];

        if (_token == null || _token!.isEmpty) {
          throw Exception('Token not found in response');
        }

        final payload = _decodeJwtPayload(_token!);
        print('JWT payload: $payload');
        if (payload?['role'] != 'Admin') {
          throw Exception('Role not authorized as Admin');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        print('New token saved: $_token');

        await Future.delayed(const Duration(milliseconds: 100));

        try {
          _user = await _authService.getProfile();
          print('User loaded: ${_user?.toJson()}');
          _isLoggedIn = true;
        } catch (e) {
          print('Profile load error: $e');
          if (e.toString().contains('Invalid or missing user ID in token')) {
            await logout();
            throw Exception('Invalid token. Please try logging in again.');
          }
          throw Exception('Failed to load profile: $e');
        }
      } else {
        String errorMessage;
        try {
          final json = jsonDecode(response.body);
          errorMessage =
              json['message'] ?? 'Login failed: ${response.statusCode}';
        } catch (e) {
          errorMessage = 'Server error: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _token = null;
    _user = null;
    _isLoggedIn = false;
    print('Logged out, token cleared');
    notifyListeners();
  }
}
