import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import '../../../services/api_client.dart';

class RoomService {
  Future<List<Room>> getRooms() async {
    final response = await ApiClient.get(
      '/api/room',
    ); // Sửa từ /api/rooms thành /api/room
    print('Get rooms response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load rooms: ${response.statusCode} ${response.body}',
      );
    }
  }
}
