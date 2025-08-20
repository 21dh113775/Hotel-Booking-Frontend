import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  final BookingService _bookingService = BookingService();

  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bookings = await _bookingService.getBookings();
    } catch (e) {
      print('Fetch bookings error: $e');
      _bookings = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    try {
      final booking = await _bookingService.createBooking(data);
      _bookings.add(booking);
      notifyListeners();
      return booking;
    } catch (e) {
      print('Create booking error: $e');
      rethrow;
    }
  }

  Future<void> confirmBooking(int id) async {
    try {
      final booking = await _bookingService.confirmBooking(id);
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = booking;
        notifyListeners();
      }
    } catch (e) {
      print('Confirm booking error: $e');
      rethrow;
    }
  }
}
