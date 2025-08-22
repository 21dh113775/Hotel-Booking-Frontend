import 'package:flutter/material.dart';
import '../models/voucher.dart';
import '../services/voucher_service.dart';

class VoucherProvider with ChangeNotifier {
  List<Voucher> _vouchers = [];
  Voucher? _appliedVoucher;
  bool _isLoading = false;
  String? _errorMessage;

  List<Voucher> get vouchers => _vouchers;
  Voucher? get appliedVoucher => _appliedVoucher;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final VoucherService _voucherService = VoucherService();

  // === GIẢI THÍCH: Tải danh sách voucher ===
  // Lý do: Gọi khi mở VoucherScreen ===
  Future<void> fetchVouchers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _vouchers = await _voucherService.getVouchers();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // === GIẢI THÍCH: Áp dụng voucher ===
  // Lý do: Gọi từ BookingFormScreen để lấy giảm giá ===
  Future<void> applyVoucher(String code) async {
    _isLoading = true;
    notifyListeners();
    try {
      _appliedVoucher = await _voucherService.applyVoucher(code);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
