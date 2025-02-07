import 'dart:convert';
import 'package:classpal_flutter_app/features/auth/models/role_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://cpserver.amrakk.rest/api/v1';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  AuthService() {
    _initialize();
  }

  // Khởi tạo PersistCookieJar để lưu trữ cookie
  Future<void> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  // Lưu cookie vào SharedPreferences
  Future<void> _saveCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));

    final cookieList = cookies.map((cookie) {
      return {
        'name': cookie.name,
        'value': cookie.value,
        'domain': cookie.domain,
        'path': cookie.path,
        'expires': cookie.expires?.millisecondsSinceEpoch,
        'httpOnly': cookie.httpOnly,
        'secure': cookie.secure,
      };
    }).toList();

    prefs.setString('cookies', jsonEncode(cookieList));
    print('Cookies đã được lưu');
  }

  // Khôi phục cookie từ SharedPreferences
  Future<void> restoreCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookiesString = prefs.getString('cookies');

    if (cookiesString != null) {
      final cookieList = (jsonDecode(cookiesString) as List).map((cookie) {
        return Cookie(cookie['name'], cookie['value'])
          ..domain = cookie['domain']
          ..path = cookie['path']
          ..expires = cookie['expires'] != null
              ? DateTime.fromMillisecondsSinceEpoch(cookie['expires'])
              : null
          ..httpOnly = cookie['httpOnly']
          ..secure = cookie['secure'];
      }).toList();

      await _cookieJar.saveFromResponse(Uri.parse(_baseUrl), cookieList);
      print('Cookies đã được khôi phục');
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(user.toMap());
    print(profileJson);
    await prefs.setString('user', profileJson);
  }

  Future<UserModel?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      return UserModel.fromMap(jsonDecode(userJson));
    }
    return null;
  }

  // Đăng nhập và lưu cookie
  Future<UserModel?> login(String emailOrPhone, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'emailOrPhone': emailOrPhone,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('Đăng nhập thành công');

        // Lưu trạng thái đăng nhập
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        UserModel user = UserModel.fromMap(response.data['data']['user']);
        await _saveUserToPrefs(user);
        return user;
      } else {
        print('Đăng nhập thất bại: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi đăng nhập: $e');
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
  Future<String?> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        // headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear(); // Clear saved headers
        return null;
      } else {
        return jsonDecode(response.body)['message'] ?? 'Logout failed';
      }
    } catch (e) {
      print('Logout error: $e');
      return 'An unexpected error occurred';
    }
  }

  // Quên mật khẩu (Forgot Password)
  Future<String?> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      print('Error during forgot password: $e');
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

          print(roles);
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

  // Xác thực qua Google
  Future<void> authenticateWithGoogle(String cartId) async {
    final googleAuthUrl =
        'http://localhost:3000/api/v1/auth/google?cartId=$cartId';
    print('Open this link in your browser to authenticate: $googleAuthUrl');
  }
}
