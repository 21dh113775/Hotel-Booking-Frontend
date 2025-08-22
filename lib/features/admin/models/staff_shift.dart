class StaffShift {
  final int id;
  final int staffId;
  final DateTime shiftDate;
  final String shiftTime;

  StaffShift({
    required this.id,
    required this.staffId,
    required this.shiftDate,
    required this.shiftTime,
  });

  // === GIẢI THÍCH: Factory fromJson để phân tích từ API response ===
  // Lý do: Đảm bảo model hợp với backend StaffShift entity, dễ map state trong provider ===
  factory StaffShift.fromJson(Map<String, dynamic> json) {
    return StaffShift(
      id: json['id'] ?? 0,
      staffId: json['staffId'] ?? 0,
      shiftDate: DateTime.parse(
        json['shiftDate'] ?? DateTime.now().toIso8601String(),
      ),
      shiftTime: json['shiftTime'] ?? '',
    );
  }
}
