class Voucher {
  final int id;
  final String code;
  final int discount;
  final DateTime expiryDate;
  final bool isActive;

  Voucher({
    required this.id,
    required this.code,
    required this.discount,
    required this.expiryDate,
    required this.isActive,
  });

  // === GIẢI THÍCH: Factory fromJson để phân tích dữ liệu từ API ===
  // Lý do: Tương thích với response backend, xử lý null nếu cần ===
  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      discount: json['discount'] ?? 0,
      expiryDate: DateTime.parse(
        json['expiryDate'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: json['isActive'] ?? false,
    );
  }
}
