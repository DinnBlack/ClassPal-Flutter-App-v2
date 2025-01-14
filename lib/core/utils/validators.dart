class Validators {
  /// Validate required text input
  static String? validateRequiredText(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  /// Validate tên
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Họ và tên không được để trống';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// Validate số điện thoại
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống';
    } else if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  /// Validate mật khẩu
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ cái';
    }
    if (!RegExp(r'[0-9!@#\$&*~]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ số hoặc ký tự đặc biệt';
    }
    return null;
  }

  /// Validate xác nhận mật khẩu
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    } else if (value != originalPassword) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  /// Validate OTP
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã OTP không được để trống';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) { // Giả sử OTP có độ dài 6 chữ số
      return 'Mã OTP không hợp lệ, phải gồm 6 chữ số';
    }
    return null;
  }
}