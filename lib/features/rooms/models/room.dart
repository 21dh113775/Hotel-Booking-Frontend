class Room {
  final int id;
  final String roomNumber;
  final double pricePerNight;
  final bool isAvailable;
  final String? description;
  final String? imageUrl;
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
      id: json['id'] ?? 0,
      roomNumber: json['roomNumber'] ?? '',
      pricePerNight: (json['pricePerNight'] ?? 0.0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
