import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import '../../../services/api_client.dart';

class RoomService {
  Future<List<Room>> getRooms() async {
    final response = await ApiClient.get('/api/room');
    print('Get rooms response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      print('Parsed jsonData: $jsonData'); // Log để debug
      List<dynamic> jsonList;

      // Kiểm tra nếu jsonData là Map và có key '$values'
      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey(r'$values')) {
        jsonList = jsonData[r'$values'] ?? [];
      } else if (jsonData is List<dynamic>) {
        // Trường hợp JSON là danh sách trực tiếp
        jsonList = jsonData;
      } else {
        jsonList = [];
        print('Unexpected JSON format: $jsonData');
      }

      print('Parsed jsonList: $jsonList'); // Log để debug
      final rooms =
          jsonList.map((json) {
            print('Parsing room: $json'); // Log mỗi phòng
            return Room.fromJson(json as Map<String, dynamic>);
          }).toList();
      print(
        'Parsed rooms: ${rooms.map((r) => r.roomNumber).toList()}',
      ); // Log danh sách phòng
      return rooms;
    } else {
      throw Exception(
        'Failed to load rooms: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Room> getRoomById(int id) async {
    final response = await ApiClient.get('/api/room/$id');
    print('Get room by ID response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return Room.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load room: ${response.statusCode} ${response.body}',
      );
    }
  }
}
