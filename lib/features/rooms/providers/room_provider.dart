import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomProvider with ChangeNotifier {
  List<Room> _rooms = [];
  bool _isLoading = false;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  final RoomService _roomService = RoomService();

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();
    try {
      _rooms = await _roomService.getRooms();
    } catch (e) {
      print('Fetch rooms error: $e');
      _rooms = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
