class Staff {
  final int id;
  final String name;
  final String phone;
  final String email;

  Staff({
    required this.id,
    required this.name,
    this.phone = '',
    this.email = '',
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as int? ?? 0,
      name: json['fullName'] as String? ?? 'Unknown',
      phone: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': name,
    'phoneNumber': phone,
    'email': email,
  };
}
