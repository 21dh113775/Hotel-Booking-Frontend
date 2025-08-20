import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<void> loadToken() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    if (_token != null) {
      try {
        _user = await _authService.getProfile();
        _isLoggedIn = true;
      } catch (e) {
        print('Load token error: $e');
        await logout();
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.register(data);
      print('Register response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        _token = json['token']; // Mong đợi { "token": "jwt_here" }
        if (_token == null) {
          throw Exception('Token not found in response');
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
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
      _isLoading = false;
      notifyListeners();
      throw Exception(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.login({
        'email': email,
        'password': password,
      });
      print('Login response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _token = json['token'];
        if (_token == null) {
          throw Exception('Token not found in response');
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        _user = await _authService.getProfile();
        _isLoggedIn = true;
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
      _isLoading = false;
      notifyListeners();
      throw Exception(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _token = null;
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
