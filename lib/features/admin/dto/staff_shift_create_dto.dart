class StaffShiftCreateDto {
  final int staffId;
  final DateTime shiftDate;
  final String shiftTime;

  StaffShiftCreateDto({
    required this.staffId,
    required this.shiftDate,
    required this.shiftTime,
  });

  // === GIẢI THÍCH: Phương thức toJson để chuyển DTO sang Map cho API call ===
  // Lý do sửa: Convert shiftDate sang UTC ISO để backend nhận đúng, tránh lỗi timezone ===
  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'shiftDate': shiftDate.toUtc().toIso8601String(),
      'shiftTime': shiftTime,
    };
  }
}
