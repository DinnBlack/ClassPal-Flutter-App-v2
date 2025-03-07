import 'package:dio/dio.dart';
import 'dart:html' as html;

class TokenManager {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://cpserver.amrakk.rest',
  ));

  /// Lưu token vào localStorage (thay thế cookie)
  static Future<void> saveCookies() async {
    print("Token đã lưu vào localStorage");
  }

  /// Khởi tạo TokenManager cho Mobile
  static Future<void> initialize() async {
    print("TokenManager Web Initialized");
  }

  static Future<String?> getCookies() async {
    final cookie = html.document.cookie;

    if (cookie == null || cookie.isEmpty) {
      return null;
    }

    final cookieMap = <String, String>{};
    for (var item in cookie.split('; ')) {
      final split = item.split('=');
      if (split.length == 2) {
        cookieMap[split[0]] = split[1];
      }
    }

    return cookieMap.isNotEmpty ? cookieMap.entries.map((e) => "${e.key}=${e.value}").join('; ') : null;
  }

  /// Xóa token khỏi localStorage
  static Future<void> clearToken() async {
    html.window.localStorage.remove('auth_token');
    print("Token đã bị xóa khỏi localStorage");
  }

  /// Gửi request với token từ localStorage
  static Future<void> sendRequestWithToken() async {
    final token = await getCookies();
    if (token == null) {
      print("Chưa có token, không thể gửi request.");
      return;
    }

    try {
      final response = await dio.get(
        '/api/your-endpoint',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("Response: ${response.data}");
    } catch (e) {
      print("Request failed: $e");
    }
  }
}
