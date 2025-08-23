class BookingUpdateDto {
  final int id;
  final String status; // Ví dụ: Pending, Confirmed, Cancelled
  final DateTime checkIn;
  final DateTime checkOut;

  BookingUpdateDto({
    required this.id,
    required this.status,
    required this.checkIn,
    required this.checkOut,
  });

  // Note: Chuyển đổi sang JSON cho API PUT
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'checkIn': checkIn.toUtc().toIso8601String(),
      'checkOut': checkOut.toUtc().toIso8601String(),
    };
  }
}
