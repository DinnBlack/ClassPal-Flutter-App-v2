import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TokenManager {
  static final Dio dio = Dio();
  static late PersistCookieJar _cookieJar;
  static const String _apiUrl = 'https://cpserver.amrakk.rest';

  /// **Khởi tạo TokenManager cho Mobile**
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    dio.interceptors.add(CookieManager(_cookieJar));

    // Xóa cookies cũ trước khi khôi phục để tránh bị lưu quá nhiều cookies không cần thiết
    await clearCookies();
    await restoreCookies();
  }

  /// **Lưu cookies vào SharedPreferences (Chỉ lưu các cookie cần thiết)**
  static Future<void> saveCookies() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(_apiUrl));

    // Chỉ lấy các cookie quan trọng
    final neededCookies = ['sessionid', 'auth_token'];
    final filteredCookies = cookies.where((c) => neededCookies.contains(c.name)).toList();

    final prefs = await SharedPreferences.getInstance();
    final cookieList = filteredCookies.map((c) => '${c.name}=${c.value}').toList();

    await prefs.setString('cookies', jsonEncode(cookieList));
  }

  /// **Khôi phục cookies từ SharedPreferences**
  static Future<void> restoreCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookieString = prefs.getString('cookies');

    if (cookieString != null) {
      final List<dynamic> cookieList = jsonDecode(cookieString);
      final cookies = cookieList.map((c) {
        final parts = c.split('=');
        return Cookie(parts[0], parts[1]);
      }).toList();

      // Chỉ lưu lại các cookie quan trọng vào PersistCookieJar
      await _cookieJar.saveFromResponse(Uri.parse(_apiUrl), cookies);
    }
  }

  /// **Xóa tất cả cookies**
  static Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }

  /// **Lấy các cookies cần thiết**
  static Future<String> getCookies() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(_apiUrl));

    // Mặc định chỉ lấy 'sessionid' và 'auth_token'
    final filter = ['sessionid', 'auth_token'];

    // Lọc cookie theo danh sách `filter`
    final filteredCookies = cookies
        .where((cookie) => filter.contains(cookie.name))
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
    return filteredCookies;
  }
}
