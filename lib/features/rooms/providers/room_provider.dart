import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomProvider with ChangeNotifier {
  List<Room> _rooms = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final RoomService _roomService = RoomService();

  Future<void> fetchRooms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _rooms = await _roomService.getRooms();
    } catch (e) {
      _errorMessage = 'Failed to load rooms: $e';
      print('Fetch rooms error: $e'); // Log thêm để debug
      _rooms = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
