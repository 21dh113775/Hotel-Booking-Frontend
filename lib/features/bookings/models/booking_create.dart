class BookingCreate {
  final int roomId;
  final int? comboId;
  final int? userId;
  final DateTime startTime;
  final DateTime endTime;
  final List<int>? drinkIds;

  BookingCreate({
    required this.roomId,
    this.comboId,
    this.userId,
    required this.startTime,
    required this.endTime,
    this.drinkIds,
  });
}
