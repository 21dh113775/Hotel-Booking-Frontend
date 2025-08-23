import 'dart:io';

class RoomUpdateDto {
  final int id;
  final String roomNumber;
  final double pricePerNight;
  final bool isAvailable;
  final String? description;
  final File? image;

  RoomUpdateDto({
    required this.id,
    required this.roomNumber,
    required this.pricePerNight,
    required this.isAvailable,
    this.description,
    this.image,
  });

  Map<String, String> toFormData() {
    return {
      'roomNumber': roomNumber,
      'pricePerNight': pricePerNight.toString(),
      'isAvailable': isAvailable.toString(),
      'description': description ?? '',
    };
  }
}
