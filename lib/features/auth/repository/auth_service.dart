import 'dart:convert';
import 'package:classpal_flutter_app/features/auth/models/role_model.dart';
import 'package:classpal_flutter_app/features/auth/repository/google_service.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config/cookie/token_manager.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService extends ProfileService {
  static const String _baseUrl = 'https://cpserver.amrakk.rest/api/v1';
  final Dio _dio = TokenManager.dio;
  static final _googleSignIn = GoogleSignIn();

  AuthService() {
    TokenManager.initialize();
  }

  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(user.toMap());
    await prefs.setString('user', profileJson);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      return UserModel.fromMap(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> saveCurrentRoles(List<String> currentRoles) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('currentRoles')) {
      await prefs.remove('currentRoles');
    }

    await prefs.setStringList('currentRoles', currentRoles);
  }


  Future<List<String>> getCurrentRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('currentRoles') ?? [];
  }


  /// Đăng nhập
  Future<UserModel?> login(String emailOrPhone, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'emailOrPhone': emailOrPhone,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          extra: {
            'withCredentials': true,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Đăng nhập thành công');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        UserModel user = UserModel.fromMap(response.data['data']['user']);
        await saveCurrentUser(user);
        print('Response Headers: ${response.headers}');

        await TokenManager.saveCookies();

        return user;
      } else {
        print('Đăng nhập thất bại: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print('Lỗi khi đăng nhập: ${e.response?.data}');
    }
    return null;
  }



  // Đăng ký (Register)
  Future<String?> register(
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

      if (response.statusCode == 201) {
        return null;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      print('Error during register: $e');
      return 'An unexpected error occurred';
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/logout',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print(response.data);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        print('Logout success');
      } else {
        return jsonDecode(response.data)['message'] ?? 'Logout failed';
      }
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Quên mật khẩu (Forgot Password)
  Future<String?> forgotPassword(String email) async {
    try {
      print(email);
      final response = await _dio.post(
        '$_baseUrl/auth/forgot-password',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'email': email,
        }),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return null;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.data);
        return responseData['message'] ?? 'Unknown error occurred';
      }
    } on DioException catch (e) {
      print('Error during forgot password: ${e.response?.data}');
      return 'An unexpected error occurred';
    }
  }

  // Đặt lại mật khẩu (Reset Password)
  Future<String?> resetPassword(
      String email, String password, String otp) async {
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

      if (response.statusCode == 200) {
        return null;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(response.body);
        return responseData['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      print('Error during reset password: $e');
      return 'An unexpected error occurred';
    }
  }

  Future<List<RoleModel>> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/get-roles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] != null) {
          List<RoleModel> roles = (data['data'] as List)
              .map((role) => RoleModel.fromMap(role))
              .toList();

          // Save the RoleModel list to SharedPreferences as a list of JSON strings
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> roleJsonList =
              roles.map((role) => jsonEncode(role.toMap())).toList();
          await prefs.setStringList('roles', roleJsonList);

          return roles;
        } else {
          throw Exception('No roles data available');
        }
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to fetch roles');
      }
    } catch (e) {
      print('Error during fetching roles: $e');
      return [];
    }
  }

  static Future<GoogleSignInAccount?> signInWithGoogle() =>
      _googleSignIn.signIn();

  Future<void> authenticateWithGoogle() async {
    const googleAuthUrl = '$_baseUrl/auth/google';
    print('Open this link in your browser to authenticate: $googleAuthUrl');

    try {
      await GoogleController().authWithGoogle(isSignIn: true);

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response);

      if (response.statusCode == 200) {
        print('Authentication successful');
      } else {
        print('Failed to authenticate');
      }
    } catch (e) {
      print('Error during Google authentication: $e');
    }
  }
}
