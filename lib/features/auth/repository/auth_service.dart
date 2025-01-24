import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final String _baseUrl = 'https://cpserver.amrakk.rest/api/v1';
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
    print(cookieList);
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

      print(response.data['data']);

      if (response.statusCode == 200) {
        print('Đăng nhập thành công');
        await _saveCookies(); // Lưu cookie
        return UserModel.fromMap(response.data['data']['user']);
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
  Future<String?> register(String name, String email, String phoneNumber,
      String password) async {
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
  Future<String?> resetPassword(String email, String password,
      String otp) async {
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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to fetch roles');
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
