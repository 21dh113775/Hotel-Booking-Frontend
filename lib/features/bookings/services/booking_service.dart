import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';
import '../../../services/api_client.dart';

class BookingService {
  Future<bool> checkAvailability(
    int roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    final response = await ApiClient.post('/api/Booking/check-availability', {
      'roomId': roomId,
      'checkIn': checkIn.toUtc().toIso8601String(),
      'checkOut': checkOut.toUtc().toIso8601String(),
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['available'] as bool;
    } else {
      throw Exception('Failed to check availability: ${response.body}');
    }
  }

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    final response = await ApiClient.post('/api/Booking', data);
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  Future<Booking> confirmBooking(int id) async {
    final response = await ApiClient.post('/api/Booking/$id/confirm', {});
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to confirm booking: ${response.body}');
    }
  }

  Future<List<Booking>> getBookings() async {
    final response = await ApiClient.get('/api/Booking');
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings: ${response.body}');
    }
  }
}
