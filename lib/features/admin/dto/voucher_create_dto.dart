import 'dart:convert'; // Import nếu cần JSON encode

class VoucherCreateDto {
  final String code;
  final int discount;
  final DateTime expiryDate;
  final bool isActive;

  VoucherCreateDto({
    required this.code,
    required this.discount,
    required this.expiryDate,
    this.isActive = true, // Mặc định active
  });

  // === GIẢI THÍCH: Phương thức toJson để chuyển DTO sang Map cho API call ===
  // Lý do sửa: Đảm bảo expiryDate convert UTC đúng, tránh lỗi datetime backend ===
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount': discount,
      'expiryDate': expiryDate.toUtc().toIso8601String(),
      'isActive': isActive,
    };
  }
}
