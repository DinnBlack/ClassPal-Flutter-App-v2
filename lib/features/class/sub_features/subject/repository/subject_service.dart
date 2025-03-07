import 'dart:convert';
import 'package:classpal_flutter_app/features/class/sub_features/grade/models/grade_type_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/cookie/token_manager.dart';
import '../../../../profile/repository/profile_service.dart';
import '../models/subject_model.dart';

class SubjectService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  SubjectService() {
    TokenManager.initialize();
  }

  Future<List<SubjectModel>> getAllSubject() async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);

      // Lấy danh sách vai trò từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? roleJsonList = prefs.getStringList('roles');

      if (roleJsonList == null) {
        print('Không tìm thấy danh sách roles trong SharedPreferences');
        return [];
      }

      final requestUrl = '$_baseUrl/subjects/${currentProfile?.groupId}';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        List<SubjectModel> subjects =
            data.map((subject) => SubjectModel.fromMap(subject)).toList();

        return subjects;
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching subject: $e');
      return [];
    }
  }

  Future<SubjectModel?> getSubjectById(String subjectId) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(
          profileId: currentProfile?.tempId ?? currentProfile?.id);

      final requestUrl =
          '$_baseUrl/subjects/${currentProfile?.groupId}/$subjectId';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print(data);

        if (data is Map<String, dynamic>) {
          return SubjectModel.fromMap(data);
        } else {
          print('Dữ liệu trả về không hợp lệ');
          return null;
        }
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error fetching subject: $e');
      return null;
    }
  }

  Future<bool> insertSubject(String name, List<String> gradeTypes) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/subjects/${currentProfile?.groupId}';

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {'name': name, 'gradeTypes': gradeTypes},
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to insert subject: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting subject: ${e.response}');
      throw e;
    }
  }

  Future<void> updateSubject(
      SubjectModel subject, String? name, List<String>? gradeTypes) async {
    try {
      final currentProfile = await ProfileService().getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/subjects/${currentProfile?.groupId}/${subject.id}';

      // Lấy danh sách grade types hiện tại từ subject
      List<GradeTypeModel> initialGradeTypes = subject.gradeTypes;

      // Danh sách tên và ID của grade types hiện tại
      List<String> currentGradeTypeNames =
          initialGradeTypes.map((gt) => gt.name).toList();
      List<String> currentGradeTypeIds =
          initialGradeTypes.map((gt) => gt.id).toList();

      // Cập nhật tên môn học nếu có thay đổi
      if (name != null && name.isNotEmpty && name != subject.name) {
        final response = await _dio.patch(
          requestUrl,
          data: jsonEncode({'name': name}),
          options: Options(headers: headers, extra: {'withCredentials': true}),
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to update subject name: ${response.data}');
        }
      }

      // Xử lý cập nhật GradeTypes nếu danh sách khác
      if (gradeTypes != null) {
        // Lọc ra các GradeTypes cần thêm mới
        List<String> toInsert = gradeTypes
            .where((name) => !currentGradeTypeNames.contains(name))
            .toList();

        print('To insert: $toInsert');

        // Lọc ra các GradeTypes cần xóa (dựa trên ID)
        List<String> toDelete = currentGradeTypeIds
            .where((id) => !gradeTypes.contains(
                initialGradeTypes.firstWhere((gt) => gt.id == id).name))
            .toList();

        print('To delete: $toDelete');

        // Thêm và xóa nếu có sự thay đổi
        if (toInsert.isNotEmpty) await insertGradeTypes(subject.id, toInsert);
        if (toDelete.isNotEmpty) await deleteGradeTypes(subject.id, toDelete);
      }
    } catch (e) {
      print('Error updating subject: $e');
      throw e;
    }
  }

  Future<bool> insertGradeTypes(
      String subjectId, List<String> gradeTypes) async {
    try {
      final currentProfile = await ProfileService().getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/subjects/${currentProfile?.groupId}/$subjectId/grade';

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode({'gradeTypes': gradeTypes}),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error inserting grade types: $e');
      throw e;
    }
  }

  Future<bool> deleteGradeTypes(
      String subjectId, List<String> gradeTypeIds) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/subjects/${currentProfile?.groupId}/$subjectId/grade';

      final response = await _dio.delete(
        requestUrl,
        data: jsonEncode({'gradeTypes': gradeTypeIds}),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting grade types: $e');
      throw e;
    }
  }

  Future<bool> deleteSubject(String subjectId) async {
    try {
      final currentProfile = await ProfileService().getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/subjects/${currentProfile?.groupId}/$subjectId';

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting grade types: $e');
      throw e;
    }
  }
}
