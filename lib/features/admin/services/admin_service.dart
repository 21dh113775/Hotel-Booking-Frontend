import 'dart:convert';
import 'dart:io';
import 'package:hotel_booking_frontend/features/admin/dto/booking/booking_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/room/room_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/room/room_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/voucher/voucher_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/models/staff.dart';
import 'package:http/http.dart' as http;
import '../../../services/api_client.dart';
import '../../auth/models/user.dart';
import '../../rooms/models/room.dart';
import '../../vouchers/models/voucher.dart';
import '../models/staff_shift.dart';
import '../dto/admin_user_update_dto.dart';
import '../../bookings/models/booking.dart';

class AdminService {
  List<dynamic> extractList(dynamic field) {
    if (field is Map<String, dynamic> && field.containsKey(r'$values')) {
      return field[r'$values'] as List<dynamic>;
    }
    if (field is List<dynamic>) {
      return field;
    }
    if (field is Map<String, dynamic>) {
      return [field];
    }
    return [];
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await ApiClient.get('/api/admin/users', withAuth: true);
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getUsers jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy danh sách user: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getUsers error: $e');
      rethrow;
    }
  }

  Future<void> updateUserRole(AdminUserUpdateDto dto) async {
    try {
      final response = await ApiClient.put(
        '/api/admin/users/update-role',
        body: dto.toJson(),
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi cập nhật role: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService updateUserRole error: $e');
      rethrow;
    }
  }

  Future<List<Room>> getRooms() async {
    try {
      final response = await ApiClient.get('/api/room', withAuth: true);
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getRooms jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => Room.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy danh sách phòng: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getRooms error: $e');
      rethrow;
    }
  }

  Future<void> createRoom(RoomCreateDto dto) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiClient.baseUrl + '/api/admin/rooms'),
      );
      request.headers.addAll(await ApiClient.getHeaders(withAuth: true));
      request.fields.addAll(dto.toFormData());
      if (dto.image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', dto.image!.path),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi tạo phòng: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService createRoom error: $e');
      rethrow;
    }
  }

  Future<void> deleteRoom(int id) async {
    try {
      final response = await ApiClient.delete(
        '/api/admin/rooms/$id',
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi xóa phòng: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService deleteRoom error: $e');
      rethrow;
    }
  }

  Future<List<Voucher>> getVouchers() async {
    try {
      final response = await ApiClient.get('/api/voucher', withAuth: true);
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getVouchers jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => Voucher.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy danh sách voucher: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getVouchers error: $e');
      rethrow;
    }
  }

  Future<void> updateVoucher(int id, VoucherCreateDto dto) async {
    try {
      final response = await ApiClient.put(
        '/api/admin/vouchers/$id',
        body: dto.toJson(),
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi cập nhật voucher: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService updateVoucher error: $e');
      rethrow;
    }
  }

  Future<void> deleteVoucher(int id) async {
    try {
      final response = await ApiClient.delete(
        '/api/admin/vouchers/$id',
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi xóa voucher: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService deleteVoucher error: $e');
      rethrow;
    }
  }

  Future<void> createVoucher(VoucherCreateDto dto) async {
    try {
      final response = await ApiClient.post(
        '/api/admin/vouchers',
        body: dto.toJson(),
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi tạo voucher: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService createVoucher error: $e');
      rethrow;
    }
  }

  Future<List<StaffShift>> getShifts(int staffId) async {
    try {
      final response = await ApiClient.get(
        '/api/staffshift/$staffId',
        withAuth: true,
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getShifts jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => StaffShift.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy ca làm việc: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getShifts error: $e');
      rethrow;
    }
  }

  Future<List<StaffShift>> getShiftsByDate(
    DateTime date, [
    int? staffId,
  ]) async {
    try {
      String url = '/api/staffshift/by-date?date=${date.toIso8601String()}';
      if (staffId != null) url += '&staffId=$staffId';
      final response = await ApiClient.get(url, withAuth: true);
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getShiftsByDate jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => StaffShift.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy ca làm việc theo ngày: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getShiftsByDate error: $e');
      rethrow;
    }
  }

  Future<void> assignShift(StaffShiftCreateDto dto) async {
    try {
      final response = await ApiClient.post(
        '/api/staffshift',
        body: dto.toJson(),
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi gán ca: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService assignShift error: $e');
      rethrow;
    }
  }

  Future<void> deleteShift(int id) async {
    try {
      final response = await ApiClient.delete(
        '/api/staffshift/$id',
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi xóa ca: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService deleteShift error: $e');
      rethrow;
    }
  }

  Future<List<Booking>> getBookings() async {
    try {
      final response = await ApiClient.get('/api/booking', withAuth: true);
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getBookings jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => Booking.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy danh sách booking: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getBookings error: $e');
      rethrow;
    }
  }

  Future<void> updateBooking(BookingUpdateDto dto) async {
    try {
      final response = await ApiClient.put(
        '/api/booking/${dto.id}',
        body: dto.toJson(),
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi cập nhật booking: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService updateBooking error: $e');
      rethrow;
    }
  }

  Future<void> updateShift(int id, StaffShiftUpdateDto dto) async {
    try {
      final response = await ApiClient.put(
        '/api/staffshift/$id',
        body: dto.toJson(),
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi cập nhật ca làm: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService updateShift error: $e');
      rethrow;
    }
  }

  Future<void> updateRoom(int id, RoomUpdateDto dto) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiClient.baseUrl + '/api/admin/rooms/$id'),
      );
      request.headers.addAll(await ApiClient.getHeaders(withAuth: true));
      request.fields.addAll(dto.toFormData());
      if (dto.image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', dto.image!.path),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi cập nhật phòng: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService updateRoom error: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      final response = await ApiClient.delete(
        '/api/booking/$id',
        withAuth: true,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Lỗi xóa booking: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService deleteBooking error: $e');
      rethrow;
    }
  }

  Future<List<Staff>> getStaffs() async {
    try {
      final response = await ApiClient.get('/api/admin/staff', withAuth: true);
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print('getStaffs jsonData: $jsonData');
        final jsonList = extractList(jsonData);
        return jsonList
            .map((json) => Staff.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Lỗi lấy danh sách nhân viên: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('AdminService getStaffs error: $e');
      rethrow;
    }
  }
}
