import 'dart:io'; // Import cho File image

class RoomCreateDto {
  final String roomNumber;
  final double pricePerNight;
  final bool isAvailable;
  final String? description;
  final File? image; // Sử dụng File cho upload hình ảnh (multipart)

  RoomCreateDto({
    required this.roomNumber,
    required this.pricePerNight,
    required this.isAvailable,
    this.description,
    this.image,
  });

  // === GIẢI THÍCH: Phương thức toFormData để chuẩn bị dữ liệu multipart cho API ===
  // Lý do sửa: Backend yêu cầu [FromForm] cho upload image, nên DTO hỗ trợ FormData thay vì JSON thuần, tránh lỗi file upload ===
  Map<String, String> toFormData() {
    return {
      'roomNumber': roomNumber,
      'pricePerNight': pricePerNight.toString(),
      'isAvailable': isAvailable.toString(),
      'description': description ?? '',
      // Image sẽ được xử lý riêng trong service (multipart file)
    };
  }
}
