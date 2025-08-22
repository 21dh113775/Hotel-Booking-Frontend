import 'dart:convert';

class RegisterDto {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final int roleId;

  RegisterDto({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'roleId': roleId,
    };
  }
}
