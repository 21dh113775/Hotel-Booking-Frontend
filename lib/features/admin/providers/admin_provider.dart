import 'package:flutter/material.dart';
import 'package:hotel_booking_frontend/features/admin/dto/booking/booking_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/room/room_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/room/room_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_create_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/staff/staff_shift_update_dto.dart';
import 'package:hotel_booking_frontend/features/admin/dto/voucher/voucher_create_dto.dart';
import '../models/staff_shift.dart';
import '../models/staff.dart';
import '../services/admin_service.dart';
import '../../auth/models/user.dart';
import '../../rooms/models/room.dart';
import '../../vouchers/models/voucher.dart';
import '../../bookings/models/booking.dart';
import '../dto/admin_user_update_dto.dart';

class AdminProvider with ChangeNotifier {
  List<User> _users = [];
  List<Room> _rooms = [];
  List<Voucher> _vouchers = [];
  List<StaffShift> _shifts = [];
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;
  List<Room> get rooms => _rooms;
  List<Voucher> get vouchers => _vouchers;
  List<StaffShift> get shifts => _shifts;
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Staff> _staffs = [];
  List<Staff> get staffs => _staffs;

  final AdminService _adminService = AdminService();

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _users = await _adminService.getUsers();
    } catch (e) {
      _errorMessage = 'Lỗi tải danh sách user: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserRole(AdminUserUpdateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.updateUserRole(dto);
      await fetchUsers();
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật role: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRooms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _rooms = await _adminService.getRooms();
    } catch (e) {
      _errorMessage = 'Lỗi tải danh sách phòng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRoom(RoomCreateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.createRoom(dto);
      await fetchRooms();
    } catch (e) {
      _errorMessage = 'Lỗi tạo phòng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRoom(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.deleteRoom(id);
      await fetchRooms();
    } catch (e) {
      _errorMessage = 'Lỗi xóa phòng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRoom(int id, RoomUpdateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.updateRoom(id, dto);
      await fetchRooms();
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật phòng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVouchers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _vouchers = await _adminService.getVouchers();
    } catch (e) {
      _errorMessage = 'Lỗi tải danh sách voucher: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVoucher(int id, VoucherCreateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.updateVoucher(id, dto);
      await fetchVouchers();
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật voucher: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVoucher(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.deleteVoucher(id);
      await fetchVouchers();
    } catch (e) {
      _errorMessage = 'Lỗi xóa voucher: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createVoucher(VoucherCreateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.createVoucher(dto);
      await fetchVouchers();
    } catch (e) {
      _errorMessage = 'Lỗi tạo voucher: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchShifts(int staffId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _shifts = await _adminService.getShifts(staffId);
    } catch (e) {
      _errorMessage = 'Lỗi tải ca làm việc: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignShift(StaffShiftCreateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.assignShift(dto);
      await fetchShifts(dto.staffId);
    } catch (e) {
      _errorMessage = 'Lỗi gán ca: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteShift(int id, int staffId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.deleteShift(id);
      await fetchShifts(staffId);
    } catch (e) {
      _errorMessage = 'Lỗi xóa ca: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateShift(int id, StaffShiftUpdateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.updateShift(id, dto);
      await fetchShifts(dto.staffId); // Giả định dto có staffId
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật ca làm: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _bookings = await _adminService.getBookings();
    } catch (e) {
      _errorMessage = 'Lỗi tải danh sách booking: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBooking(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.deleteBooking(id);
      await fetchBookings();
    } catch (e) {
      _errorMessage = 'Lỗi xóa booking: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBooking(BookingUpdateDto dto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _adminService.updateBooking(dto);
      await fetchBookings();
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật booking: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchShiftsByDate(DateTime date, [int? staffId]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _shifts = await _adminService.getShiftsByDate(date, staffId);
    } catch (e) {
      _errorMessage = 'Lỗi tải ca làm việc theo ngày: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStaffs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _staffs = await _adminService.getStaffs();
    } catch (e) {
      _errorMessage = 'Lỗi tải danh sách nhân viên: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
