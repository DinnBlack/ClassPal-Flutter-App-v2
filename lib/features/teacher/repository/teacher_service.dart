import 'dart:convert';

import 'package:classpal_flutter_app/features/invitation/repository/invitation_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/cookie/token_manager.dart';
import '../../auth/models/role_model.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';

class TeacherService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  TeacherService() {
    TokenManager.initialize();
  }

  Future<bool> insertTeacher(String displayName, String email) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/profiles/${currentProfile?.groupType}/${currentProfile?.groupId}';

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {
            'displayName': displayName,
            'roles': ['Teacher']
          },
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 201) {
        final teacherProfile = ProfileModel.fromMap(response.data['data'][0]);
        print(teacherProfile);

        await InvitationService()
            .sendInvitationMailForTeacherSchool(email, teacherProfile.id);

        return true;
      } else {
        throw Exception('Failed to insert teacher: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting teacher: ${e.response}');
      throw e;
    }
  }

  Future<bool> insertBatchTeacher(List<Map<String, String>> teachers) async {
    try {
      final results = await Future.wait(
        teachers.map((teacher) => insertTeacher(teacher["name"]!, teacher["email"]!)),
      );
      return results.every((result) => result == true);
    } catch (e) {
      print("Error inserting teachers: $e");
      return false;
    }
  }

  Future<bool> deleteTeacher(String teacherId) async {
    try {
      return deleteProfile(teacherId);
    } catch (e) {
      print("Error delete teachers: $e");
      return false;
    }
  }

  Future<List<ProfileModel>> getAllTeacher() async {
    List<ProfileModel> teachers = [];

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

      List<RoleModel> roles = roleJsonList
          .map((roleJson) => RoleModel.fromMap(jsonDecode(roleJson)))
          .toList();

      // Tìm role ID của Student
      String? teacherRoleId;
      for (var role in roles) {
        if (role.name == "Teacher") {
          teacherRoleId = role.id;
          break;
        }
      }

      if (teacherRoleId == null) {
        print('Không tìm thấy role Teacher');
        return [];
      }

      final requestUrl =
          '$_baseUrl/profiles/${currentProfile?.groupType}/${currentProfile?.groupId}';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        List<ProfileModel> allProfiles = data
            .map((profileData) => ProfileModel.fromMap(profileData))
            .toList();

        // Lọc danh sách chỉ chứa học sinh
        teachers = allProfiles
            .where((profile) => profile.roles.contains(teacherRoleId))
            .toList();

        return teachers;
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching teachers by ID: ${e.response!.data}');
      return [];
    }
  }
}
