class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    if (value.length < 2) {
      return 'Họ tên quá ngắn';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Nới lỏng regex để chấp nhận số VN (bắt đầu bằng 0 hoặc +84, 9-10 số)
    final phoneRegex = RegExp(r'^(0|\+84)\d{9,10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại phải bắt đầu bằng 0 hoặc +84, dài 10-11 số';
    }
    return null;
  }
}
