import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class UserService extends ProfileService {
  static const String _baseUrl = 'https://cpserver.amrakk.rest/api/v1';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  UserService() {
    _initialize();
  }

  // Khởi tạo PersistCookieJar để lưu trữ cookie
  Future<void> _initialize() async {
    if (kIsWeb) {
      // Xử lý cho nền tảng web
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final cookieStorage = FileStorage('${directory.path}/cookies');
      _cookieJar = PersistCookieJar(storage: cookieStorage);
      _dio.interceptors.add(CookieManager(_cookieJar));
      // Khôi phục cookies khi khởi tạo
      await restoreCookies();
    }
  }

  // Đăng nhập và lưu cookie
  Future<UserModel?> getUserById(String userId) async {
    try {
      await _initialize();
      final response = await _dio.get(
        '$_baseUrl/users/$userId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print(response.data);

      if (response.statusCode == 200) {
        print('Get user successfully!');

        UserModel user = UserModel.fromMap(response.data['data']['user']);
        return user;
      } else {
        print('Get user failure: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print('Lỗi khi lấy user: ${e.response!.data}');
    }
    print('Lỗi khi lấy user');
    return null;
  }
}
