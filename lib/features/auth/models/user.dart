class User {
  final int id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? 'Customer',
    );
  }
}
