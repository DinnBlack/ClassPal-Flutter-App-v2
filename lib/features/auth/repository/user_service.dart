import '../models/user_model.dart';
import 'user_data.dart';

class UserService {
  static UserModel? _loggedInUser;

  // Đăng nhập (Login)
  Future<UserModel?> login(String emailOrPhoneNumber, String password) async {
    await Future.delayed(Duration(seconds: 2));
    for (var user in users) {
      if ((user.email == emailOrPhoneNumber ||
              user.phoneNumber == emailOrPhoneNumber) &&
          user.password == password) {
        _loggedInUser = user;
        return user;
      }
    }
    return null;
  }

  // Đăng ký (Register)
  Future<bool> register(
      String name, String email, String? phoneNumber, String password) async {
    await Future.delayed(Duration(seconds: 2));
    for (var user in users) {
      if (user.email == email) {
        return false;
      }
    }

    users.add(UserModel(
      userId: 'U${users.length + 1}',
      name: name,
      email: email,
      phoneNumber: phoneNumber ?? '',
      password: password,
      schoolIds: [],
      classIds: [],
    ));
    return true;
  }

  // Đăng xuất (Logout)
  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
    _loggedInUser = null;
  }

  static Future<UserModel?> get loggedInUser async {
    await Future.delayed(Duration(milliseconds: 500));
    return _loggedInUser;
  }

  // Kiểm tra quyền người dùng (Check user permissions)
  Future<bool> hasPermission(String role) async {
    UserModel? user = _loggedInUser;
    if (user == null) return false;

    await Future.delayed(Duration(seconds: 1));
    switch (role) {
      case 'principal':
        return user.schoolIds.isNotEmpty;

      case 'teacher':
        return user.schoolIds.isNotEmpty && user.classIds.isNotEmpty;

      case 'parent':
        return true;

      case 'student':
        return true;

      default:
        return false;
    }
  }
}
