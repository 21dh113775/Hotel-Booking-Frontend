import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BookingService? _bookingService;

  void initialize(BuildContext context) {
    _bookingService = BookingService(context: context);
  }

  Future<void> fetchBookings() async {
    if (_bookingService == null) {
      throw Exception(
        'BookingService not initialized. Call initialize(context) first.',
      );
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _bookings = await _bookingService!.getBookings();
    } catch (e) {
      _errorMessage = e.toString();
      _bookings = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkAvailability(
    int roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    if (_bookingService == null) {
      throw Exception(
        'BookingService not initialized. Call initialize(context) first.',
      );
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final request = AvailabilityRequest(
        roomId: roomId,
        checkIn: checkIn.toUtc(),
        checkOut: checkOut.toUtc(),
      );
      print('Availability request: ${request.toJson()}');
      final result = await _bookingService!.checkAvailability(request);
      _isLoading = false;
      notifyListeners();
      return result['available'] ?? false;
    } catch (e) {
      _errorMessage = e.toString();
      print('Check availability error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Booking?> createBooking({
    required int roomId,
    int? comboId,
    required DateTime startTime,
    required DateTime endTime,
    List<int>? drinkIds,
  }) async {
    if (_bookingService == null) {
      throw Exception(
        'BookingService not initialized. Call initialize(context) first.',
      );
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final booking = await _bookingService!.createBooking(
        roomId: roomId,
        comboId: comboId,
        startTime: startTime.toUtc(),
        endTime: endTime.toUtc(),
        drinkIds: drinkIds,
      );
      _bookings.add(booking);
      _isLoading = false;
      notifyListeners();
      return booking;
    } catch (e) {
      _errorMessage = e.toString();
      print('Create booking error: $e');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> confirmBooking(int id) async {
    if (_bookingService == null) {
      throw Exception(
        'BookingService not initialized. Call initialize(context) first.',
      );
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final booking = await _bookingService!.confirmBooking(id);
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = booking;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('Confirm booking error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
