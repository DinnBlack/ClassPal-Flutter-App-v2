import 'dart:convert';
import 'dart:io';

import 'package:classpal_flutter_app/features/class/sub_features/post/models/post_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../profile/repository/profile_service.dart';

class PostService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  PostService() {
    _initialize();
  }

  // Khởi tạo PersistCookieJar để lưu trữ cookie
  Future<void> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Restore cookies when initializing
    await restoreCookies();
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

  Future<void> insertNews(File? imageFile, String content) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) throw Exception('Profile not found');

      final requestUrl = '$_baseUrl/news/${profile.groupId}';
      final headers = {
        'Cookie': cookieHeader,
        'x-profile-id': profile.id,
        'Content-Type': "multipart/form-data"
      };

      FormData formData = FormData.fromMap({
        "content": content,
        "targetRoles": [],
      });

      if (imageFile != null && imageFile.existsSync()) {
        String fileName = imageFile.path.split("/").last.replaceAll("'", "");
        MultipartFile file = await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType("image", "png"),
        );
        formData.files.add(MapEntry("image", file));
      }

      final response = await _dio.post(
        requestUrl,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("News inserted successfully!");
        return response.data['data'];
      } else {
        throw Exception('Lỗi khi chèn tin tức: ${response.data}');
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception('Lỗi khi gửi yêu cầu insert news: ${e.response?.data}');
    }
  }


  Future<List<PostModel>> getGroupNews() async {
    try {
      await _initialize();

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) {
        print('Không có profile nào trong SharedPreferences');
        return [];
      }

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      // Lấy thời gian từ 3 ngày trước
      final DateTime fromDate =
          DateTime.now();

      // Tạo query parameters
      final queryParams = {
        'from': fromDate.toIso8601String(),
        'limit': '10',
        'targetRoles': [],
      };

      final requestUrl = '$_baseUrl/news';

      // Headers với thông tin user
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile.id,
      };

      // Gọi API
      final response = await _dio.get(
        requestUrl,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      // Xử lý response
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        print('done: $data');
        return data.map((json) => PostModel.fromMap(json)).toList();
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode} - ${response.data}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy tin tức nhóm: $e');
      return [];
    }
  }
}
