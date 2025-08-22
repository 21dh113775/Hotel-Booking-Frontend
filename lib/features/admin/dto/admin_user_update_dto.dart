class AdminUserUpdateDto {
  final int userId;
  final int roleId;

  AdminUserUpdateDto({required this.userId, required this.roleId});

  // === GIẢI THÍCH: Phương thức toJson để chuyển DTO sang Map cho API call ===
  // Lý do sửa: Đảm bảo dữ liệu gửi đúng định dạng JSON cho backend PUT, tránh lỗi serialize ===
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'roleId': roleId};
  }
}
