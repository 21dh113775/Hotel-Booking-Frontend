import 'dart:convert';

class VoucherCreateDto {
  final String code;
  final int discount;
  final DateTime expiryDate;
  final bool isActive;

  VoucherCreateDto({
    required this.code,
    required this.discount,
    required this.expiryDate,
    this.isActive = true,
  });

  // Note: Chuyển đổi sang JSON cho API POST/PUT
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount': discount,
      'expiryDate': expiryDate.toUtc().toIso8601String(),
      'isActive': isActive,
    };
  }
}
