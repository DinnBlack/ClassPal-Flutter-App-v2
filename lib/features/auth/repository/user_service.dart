import 'dart:convert';
import '../models/user_model.dart';
import 'user_data.dart';
import 'package:http/http.dart' as http;

class UserService {
  static UserModel? _loggedInUser;
  final String _baseUrl = 'https://cpserver.amrakk.resst/api/v1/';

  // Đăng nhập (Login)
  Future<UserModel?> login(String emailOrPhoneNumber, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    for (var user in users) {
      if (user.emailOrPhoneNumber == emailOrPhoneNumber &&
          user.password == password) {
        _loggedInUser = user;
        return user;
      }
    }
    return null;
  }

  // Đăng nhập (Login) fetch Api
  // Future<UserModel?> login(String emailOrPhoneNumber, String password) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'emailOrPhoneNumber': emailOrPhoneNumber,
  //         'password': password,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return UserModel.fromMap(data);
  //     } else {
  //       throw Exception('Login failed: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error during login: $e');
  //     return null;
  //   }
  // }

  // Đăng ký (Register)
  Future<bool> register(
      String name, String emailOrPhoneNumber, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    for (var user in users) {
      if (user.emailOrPhoneNumber == emailOrPhoneNumber) {
        return false;
      }
    }

    users.add(UserModel(
      userId: 'U${users.length + 1}',
      name: name,
      emailOrPhoneNumber: emailOrPhoneNumber,
      password: password,
      schoolIds: [],
      classIds: [],
    ));
    return true;
  }

  // Đăng ký (Register) fetch Api
  // Future<bool> register(
  //     String name, String emailOrPhoneNumber,  String password) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'name': name,
  //         'emailOrPhoneNumber': emailOrPhoneNumber,
  //         'password': password,
  //       }),
  //     );
  //
  //     return response.statusCode == 201;
  //   } catch (e) {
  //     print('Error during register: $e');
  //     return false;
  //   }
  // }

  // Đăng xuất (Logout)
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 2));
    _loggedInUser = null;
  }

// Đăng xuất (Logout) fetch Api
// Future<void> logout() async {
//   try {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/logout'),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     if (response.statusCode != 200) {
//       throw Exception('Logout failed: ${response.body}');
//     }
//   } catch (e) {
//     print('Error during logout: $e');
//   }
// }
}
