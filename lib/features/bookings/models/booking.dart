class Booking {
  final int id;
  final int userId;
  final int roomId;
  final int? comboId;
  final DateTime bookingTime;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;
  final int? createdBy;
  final DateTime createdAt;
  final List<BookingDrink> bookingDrinks;

  Booking({
    required this.id,
    required this.userId,
    required this.roomId,
    this.comboId,
    required this.bookingTime,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    this.createdBy,
    required this.createdAt,
    required this.bookingDrinks,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      comboId: json['comboId'],
      bookingTime: DateTime.parse(
        json['bookingTime'] ?? DateTime.now().toIso8601String(),
      ),
      checkIn: DateTime.parse(
        json['checkIn'] ?? DateTime.now().toIso8601String(),
      ),
      checkOut: DateTime.parse(
        json['checkOut'] ?? DateTime.now().toIso8601String(),
      ),
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'] ?? 'Pending',
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      bookingDrinks:
          (json['bookingDrinks'] as List? ?? [])
              .map((e) => BookingDrink.fromJson(e))
              .toList(),
    );
  }
}

class BookingDrink {
  final int id;
  final int bookingId;
  final int drinkId;
  final int quantity;

  BookingDrink({
    required this.id,
    required this.bookingId,
    required this.drinkId,
    required this.quantity,
  });

  factory BookingDrink.fromJson(Map<String, dynamic> json) {
    return BookingDrink(
      id: json['id'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      drinkId: json['drinkId'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }
}
