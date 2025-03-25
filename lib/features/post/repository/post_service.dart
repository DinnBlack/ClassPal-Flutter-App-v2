import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../core/config/cookie/token_manager.dart';
import '../../profile/repository/profile_service.dart';
import '../models/post_model.dart';

class PostService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  PostService() {
    TokenManager.initialize();
  }

  Future<File> compressImage(File file) async {
    final targetPath = '${file.path}_compressed.jpg';
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 70, // Giảm chất lượng xuống 70%
    );
    return File(result!.path);
  }

  Future<void> insertNews(File? imageFile, String content) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(
          profileId: currentProfile?.id,
          contentType: 'multipart/form-data'
      );
      final requestUrl = '$_baseUrl/news/${currentProfile?.groupId}';

      FormData formData = FormData.fromMap({
        "content": content,
        "targetRoles": [],
      });

      if (imageFile != null && imageFile.existsSync()) {
        // Giảm kích thước ảnh trước khi upload
        File compressedImage = await compressImage(imageFile);
        String fileName = compressedImage.path.split("/").last.replaceAll("'", "");

        MultipartFile file = await MultipartFile.fromFile(
          compressedImage.path,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        );

        formData.files.add(MapEntry("image", file));
      }

      print('insert news');

      final response = await _dio.post(
        requestUrl,
        data: formData,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        print("News inserted successfully!");
        return response.data['data'];
      } else {
        throw Exception('Lỗi khi chèn tin tức: ${response.data}');
      }
    } on DioException catch (e) {
      print('Loi: ${e.response?.data}');
      throw Exception('Lỗi khi gửi yêu cầu insert news: ${e.response?.data}');
    }
  }

  Future<List<PostModel>> getGroupNews() async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      // Lấy thời gian từ 3 ngày trước
      final DateTime fromDate = DateTime.now();

      // Tạo query parameters
      final queryParams = {
        'from': fromDate.toIso8601String(),
        'limit': '10',
        'targetRoles': [],
      };
      final requestUrl = '$_baseUrl/news';

      // Gọi API
      final response = await _dio.get(
        requestUrl,
        queryParameters: queryParams,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final DateTime fromDate = DateTime.now();

      final queryParams = {
        'from': fromDate.toIso8601String(),
        'limit': '10',
        'targetRoles': [],
      };

      final requestUrl = '$_baseUrl/news';
      final headers = await buildHeaders(profileId: profileId);

      final response = await _dio.get(
        requestUrl,
        queryParameters: queryParams,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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

      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/news/${currentProfile?.groupId}/$newsId';
      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
