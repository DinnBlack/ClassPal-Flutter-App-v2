import 'dart:convert';

import 'package:classpal_flutter_app/features/post/sub_feature/comment/model/comment_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:dio/dio.dart';

import '../../../../../core/config/cookie/token_manager.dart';

class CommentService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  CommentService() {
    TokenManager.initialize();
  }

  Future<bool> insertComment(String newsId, String content) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/comments/$newsId';

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {
            'content': content,
          },
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/comments/$newsId';

      // Gọi API
      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/comments/$newsId/latest';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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

  Future<bool> updateComment(
      String newsId, String commentId, String newContent) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/comments/$newsId/$commentId';

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode({'content': newContent}),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating comment: $e');
      return false;
    }
  }

  Future<bool> deleteComment(String newsId, String commentId) async {
    try {

      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/comments/$newsId/$commentId';

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }
}
