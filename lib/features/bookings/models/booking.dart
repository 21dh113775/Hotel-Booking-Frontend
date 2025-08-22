import 'package:hotel_booking_frontend/features/auth/models/user.dart';
import 'package:hotel_booking_frontend/features/rooms/models/room.dart';

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
  final int createdBy;
  final DateTime createdAt;
  final User? user;
  final Room? room;
  final Combo? combo;
  final List<BookingDrink>? bookingDrinks;

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
    required this.createdBy,
    required this.createdAt,
    this.user,
    this.room,
    this.combo,
    this.bookingDrinks,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Note: Helper extractList để xử lý JSON preserved
    List<dynamic> extractList(dynamic field) {
      if (field is Map<String, dynamic> && field.containsKey(r'$values')) {
        return field[r'$values'] as List<dynamic>;
      }
      if (field is List<dynamic>) {
        return field;
      }
      return [];
    }

    // Note: Xử lý reference {$ref: x} bằng fallback null
    Map<String, dynamic>? extractObject(dynamic field) {
      if (field is Map<String, dynamic> && field.containsKey(r'$ref')) {
        return null; // Fallback null nếu là reference, tránh parse fail
      }
      return field as Map<String, dynamic>?;
    }

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
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      createdBy: json['createdBy'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      user:
          json['user'] != null
              ? User.fromJson(extractObject(json['user']) ?? {})
              : null, // Sử dụng extractObject để fix reference
      room:
          json['room'] != null
              ? Room.fromJson(extractObject(json['room']) ?? {})
              : null,
      combo:
          json['combo'] != null
              ? Combo.fromJson(extractObject(json['combo']) ?? {})
              : null,
      bookingDrinks:
          json['bookingDrinks'] != null
              ? extractList(json['bookingDrinks'])
                  .map((e) => BookingDrink.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
    );
  }
}

class Combo {
  final int id;
  final String name;
  final String? description;
  final String comboType;
  final double price;

  Combo({
    required this.id,
    required this.name,
    this.description,
    required this.comboType,
    required this.price,
  });

  factory Combo.fromJson(Map<String, dynamic> json) {
    return Combo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      comboType: json['comboType'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}

class BookingDrink {
  final int id;
  final int drinkId;
  final int quantity;
  final Drink drink;

  BookingDrink({
    required this.id,
    required this.drinkId,
    required this.quantity,
    required this.drink,
  });

  factory BookingDrink.fromJson(Map<String, dynamic> json) {
    return BookingDrink(
      id: json['id'] ?? 0,
      drinkId: json['drinkId'] ?? 0,
      quantity: json['quantity'] ?? 1,
      drink: Drink.fromJson(json['drink'] ?? {}),
    );
  }
}

class Drink {
  final int id;
  final String name;
  final double price;
  final String? imageUrl;

  Drink({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}

class AvailabilityRequest {
  final int roomId;
  final DateTime checkIn;
  final DateTime checkOut;

  AvailabilityRequest({
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'checkIn': checkIn.toUtc().toIso8601String(),
      'checkOut': checkOut.toUtc().toIso8601String(),
    };
  }
}
