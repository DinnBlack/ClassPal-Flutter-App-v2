import 'dart:convert';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static UserModel? _loggedInUser;
  final String _baseUrl = 'https://cpserver.amrakk.rest/api/v1';

  // Đăng nhập (Login)
  Future<UserModel?> login(String emailOrPhone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailOrPhone': emailOrPhone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];
        _loggedInUser = UserModel.fromMap(userData);
        return _loggedInUser;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Đăng ký (Register)
  Future<bool> register(
      String name, String email, String phoneNumber, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error during register: $e');
      return false;
    }
  }

  // Đăng xuất (Logout)
  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.body}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Quên mật khẩu (Forgot Password)
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error during forgot password: $e');
      return false;
    }
  }

  // Đặt lại mật khẩu (Reset Password)
  Future<bool> resetPassword(String email, String password, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'otp': otp,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error during reset password: $e');
      return false;
    }
  }

  // Lấy danh sách vai trò (Get Roles)
  Future<List<String>?> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/get-roles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['roles']);
      } else {
        throw Exception('Failed to fetch roles: ${response.body}');
      }
    } catch (e) {
      print('Error during fetching roles: $e');
      return null;
    }
  }

  // Xác thực qua Google
  Future<void> authenticateWithGoogle(String cartId) async {
    final googleAuthUrl =
        'http://localhost:3000/api/v1/auth/google?cartId=$cartId';
    print('Open this link in your browser to authenticate: $googleAuthUrl');
  }
}
