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
    final id = json['id'];
    if (id == null || id == 0) {
      throw Exception(
        'Invalid user ID in profile response, Response: ${json.toString()}',
      );
    }
    return User(
      id: id,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? 'Customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}
