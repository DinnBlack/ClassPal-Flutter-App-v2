import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

import '../../profile/repository/profile_service.dart';
import '../models/post_model.dart';

class PostService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  PostService() {
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

  Future<void> insertNews(File? imageFile, String content) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/news/${currentProfile?.groupId}';
      final headers = {
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
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

      print(response.statusCode);

      if (response.statusCode == 201) {
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

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      // Lấy thời gian từ 3 ngày trước
      final DateTime fromDate = DateTime.now();

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
        'x-profile-id': currentProfile?.id,
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

  Future<List<PostModel>> getMultiGroupNews() async {
    try {
      final profiles = await getUserProfiles();
      print(profiles);

      if (profiles.isEmpty) {
        print('Không có profile nào!');
        return [];
      }

      List<PostModel> allNews = [];

      for (var profile in profiles) {
        final news = await getGroupNewsForProfile(profile.id);
        allNews.addAll(news);
      }

      // 🔥 Sắp xếp theo thời gian giảm dần (Mới nhất trước)
      allNews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return allNews;
    } catch (e) {
      print('Lỗi khi lấy tin tức nhóm: $e');
      return [];
    }
  }


  // ✅ Viết thêm hàm này để hỗ trợ gọi API theo từng profile
  Future<List<PostModel>> getGroupNewsForProfile(String profileId) async {
    try {
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final DateTime fromDate = DateTime.now();

      final queryParams = {
        'from': fromDate.toIso8601String(),
        'limit': '10',
        'targetRoles': [],
      };

      final requestUrl = '$_baseUrl/news';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profileId,
      };

      final response = await _dio.get(
        requestUrl,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => PostModel.fromMap(json)).toList();
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode} - ${response.data}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy tin tức nhóm với profile ID $profileId: $e');
      return [];
    }
  }

  Future<void> deleteNews(String newsId) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();
      final requestUrl = '$_baseUrl/news/${currentProfile?.groupId}/$newsId';
      final headers = {
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };
      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        print("News deleted successfully!");
      } else {
        throw Exception('Error deleting news: ${response.data}');
      }
    } catch (e) {
      print('Error deleting news: $e');
    }
  }
}
