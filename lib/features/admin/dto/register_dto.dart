// lib/models/register_dto.dart
class RegisterDto {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final int roleId; // Thêm roleId để gửi vai trò

  RegisterDto({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.roleId,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'roleId': roleId,
  };
}
