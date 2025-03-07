import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TokenManager {
  static final Dio dio = Dio();
  static late PersistCookieJar _cookieJar;
  static const String _apiUrl = 'https://cpserver.amrakk.rest';

  /// Khởi tạo TokenManager cho Mobile
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    dio.interceptors.add(CookieManager(_cookieJar));
    await restoreCookies();
    print("TokenManager Mobile Initialized");
  }

  /// Lưu cookies vào SharedPreferences
  static Future<void> saveCookies() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(_apiUrl));
    final prefs = await SharedPreferences.getInstance();
    final cookieList = cookies.map((c) => '${c.name}=${c.value}').toList();
    await prefs.setString('cookies', jsonEncode(cookieList));
    print("Cookie trên Mobile đã lưu: $cookieList");
  }

  /// Lấy cookies từ SharedPreferences
  static Future<void> restoreCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookieString = prefs.getString('cookies');
    if (cookieString != null) {
      final List<dynamic> cookieList = jsonDecode(cookieString);
      final cookies = cookieList.map((c) {
        final parts = c.split('=');
        return Cookie(parts[0], parts[1]);
      }).toList();
      await _cookieJar.saveFromResponse(Uri.parse(_apiUrl), cookies);
      print("Cookie trên Mobile khôi phục: $cookieList");
    }
  }

  /// Xóa cookies
  static Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
    print("Cookie trên Mobile đã bị xóa!");
  }

  /// Lấy tất cả cookies hiện có
  static Future<String> getCookies() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(_apiUrl));
    final cookieString = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    print("Cookie trên Mobile hiện tại: $cookieString");
    return cookieString;
  }
}
