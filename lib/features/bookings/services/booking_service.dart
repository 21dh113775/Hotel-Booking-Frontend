import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/booking.dart';
import '../../../services/api_client.dart';
import 'package:flutter/material.dart';

class BookingService {
  final BuildContext? context;

  BookingService({this.context});

  Future<List<Booking>> getBookings() async {
    final response = await ApiClient.get('/api/booking', withAuth: true);
    print('Get bookings response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      final List<dynamic> jsonList =
          jsonData is List ? jsonData : jsonData[r'$values'] ?? [];
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load bookings: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> checkAvailability(
    AvailabilityRequest request,
  ) async {
    final body = request.toJson();
    print('Check availability body: $body');
    final response = await ApiClient.post(
      '/api/booking/check-availability',
      body: body,
      withAuth: true,
    );
    print(
      'Check availability response: ${response.statusCode} ${response.body}',
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to check availability: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Booking> createBooking({
    required int roomId,
    int? comboId,
    required DateTime startTime,
    required DateTime endTime,
    List<int>? drinkIds,
  }) async {
    if (context == null) {
      throw Exception('Context is required to access AuthProvider');
    }
    final authProvider = Provider.of<AuthProvider>(context!, listen: false);
    if (!authProvider.isLoggedIn ||
        authProvider.user == null ||
        authProvider.user!.id == 0) {
      throw Exception(
        'User must be logged in with a valid user ID to create a booking',
      );
    }
    final body = {
      'roomId': roomId,
      'comboId': comboId,
      'userId': authProvider.user!.id, // Đảm bảo userId hợp lệ
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'drinkIds': drinkIds,
    };
    print('Create booking body: $body');
    final response = await ApiClient.post(
      '/api/booking',
      body: body,
      withAuth: true,
    );
    print('Create booking response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to create booking: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Booking> confirmBooking(int id) async {
    final response = await ApiClient.post(
      '/api/booking/$id/confirm',
      body: {},
      withAuth: true,
    );
    print('Confirm booking response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to confirm booking: ${response.statusCode} ${response.body}',
      );
    }
  }
}
