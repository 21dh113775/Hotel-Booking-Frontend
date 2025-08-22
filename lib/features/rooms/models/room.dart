class Room {
  final int id;
  final String roomNumber;
  final double pricePerNight;
  final bool isAvailable;
  final String? description; // Cho phép null
  final String? imageUrl; // Cho phép null
  final DateTime createdAt;

  Room({
    required this.id,
    required this.roomNumber,
    required this.pricePerNight,
    required this.isAvailable,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int? ?? 0,
      roomNumber: json['roomNumber'] as String? ?? '',
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? false,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
