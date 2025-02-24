import 'dart:convert';

import 'package:classpal_flutter_app/features/post/sub_feature/comment/model/comment_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CommentService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  CommentService() {
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

  Future<bool> insertComment(String newsId, String content) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/comments/$newsId';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {
            'content': content,
          },
        ),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("Comment inserted successfully!");
        return true;
      } else {
        print("Comment inserted failure ${response.data['data']}!");
        return false;
      }
    } on DioException catch (e) {
      print('Fail create comment: ${e.response?.data}');
      return false;
    }
  }

  Future<List<CommentModel>> getCommentsByNewsId(String newsId) async {
    try {
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/comments/$newsId';

      // Headers với thông tin user
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      // Gọi API
      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers),
      );

      // Xử lý response
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        print('done: $data');
        return data.map((json) => CommentModel.fromMap(json)).toList();
      } else {
        print('Lỗi khi lấy dữ liệu: ${response.statusCode} - ${response.data}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy comment: $e');
      return [];
    }
  }

  Future<List<CommentModel>> getLatestComments(String newsId) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/comments/$newsId/latest';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => CommentModel.fromMap(json)).toList();
      } else {
        print('Error fetching latest comments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching latest comments: $e');
      return [];
    }
  }

  Future<bool> updateComment(String newsId, String commentId, String newContent) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/comments/$newsId/$commentId';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode({'content': newContent}),
        options: Options(headers: headers),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating comment: $e');
      return false;
    }
  }

  Future<bool> deleteComment(String newsId, String commentId) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/comments/$newsId/$commentId';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }

}
