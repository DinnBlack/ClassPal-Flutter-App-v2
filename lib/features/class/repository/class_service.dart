import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/cookie/token_manager.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../models/class_model.dart';

class ClassService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  ClassService() {
    TokenManager.initialize();
  }

  // Lưu profile vào Shared Preferences
  Future<void> saveCurrentClass(ClassModel currentClass) async {
    final prefs = await SharedPreferences.getInstance();
    final currentClassJson = jsonEncode(currentClass.toMap());
    await prefs.setString('currentClass', currentClassJson);
  }

  // Lấy profile từ Shared Preferences
  Future<ClassModel?> getCurrentClass() async {
    final prefs = await SharedPreferences.getInstance();
    final currentClassJson = prefs.getString('currentClass');

    if (currentClassJson != null) {
      return ClassModel.fromMap(jsonDecode(currentClassJson));
    } else {
      return null;
    }
  }

  Future<Map<String, List<dynamic>>> getAllClassPersonal() async {
    List<ClassModel> classes = [];
    List<ProfileModel> classProfiles = [];

    try {
      final profiles = await getUserProfiles();
      for (var profile in profiles) {
        if (profile.groupType != 1) {
          continue;
        }
        final headers = await buildHeaders(profileId: profile.id);

        classProfiles.add(profile);

        final requestUrl = '$_baseUrl/classes/${profile.groupId}';

        final response = await _dio.get(
          requestUrl,
          options: Options(headers: headers, extra: {'withCredentials': true}),
        );

        if (response.statusCode == 200) {
          classes.add(ClassModel.fromMap(response.data['data']));
        } else if (response.statusCode == 404) {
          print('Không tìm thấy lớp với ID profile: ${profile.id}');
          return {'profiles': classProfiles, 'classes': []};
        } else {
          print(
              'Lỗi khi lấy lớp: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
          throw Exception('Failed to fetch class by ID: ${response.data}');
        }
      }
      return {'profiles': classProfiles, 'classes': classes};
    } catch (e) {
      print('Error fetching class by ID: $e');
      return {'profiles': [], 'classes': []};
    }
  }

  Future<List<ClassModel>> getAllClassSchool() async {
    List<ClassModel> classes = [];

    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);

      final response = await _dio.get(
        '$_baseUrl/classes/school/${currentProfile?.groupId}',
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        classes = (response.data['data'] as List<dynamic>)
            .map((profile) =>
                ClassModel.fromMap(profile as Map<String, dynamic>))
            .toList();
        return classes;
      } else {
        print(
            'Lỗi khi lấy lớp: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        throw Exception('Failed to fetch class by ID: ${response.data}');
      }
    } catch (e) {
      print('Error fetching classes by School ID: $e');
      return classes;
    }
  }

  // Insert personal class
  Future<ClassModel> insertPersonalClass(String name, File? avatarUrl) async {
    try {
      final headers = await buildHeaders();
      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/class-icon.png';

      final response = await _dio.post(
        '$_baseUrl/classes',
        data: jsonEncode(
          {
            'name': name,
            'avatarUrl': finalAvatarUrl,
          },
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 201) {
        final classData = (response.data['data'] as List)
            .expand((data) => [ClassModel.fromMap(data)])
            .first;

        return classData;
      } else {
        throw Exception('Failed to insert personal class: ${response.data}');
      }
    } catch (e) {
      print('Error inserting personal class: $e');
      throw e;
    }
  }

  Future<ClassModel> insertSchoolClass(String name, String? avatarUrl) async {
    try {
      final headers = await buildHeaders();
      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/class-icon.png';

      final currentProfile = await getCurrentProfile();

      final response = await _dio.post(
        '$_baseUrl/classes/${currentProfile?.groupId}',
        data: jsonEncode(
          {
            'name': name,
            'avatarUrl': finalAvatarUrl,
          },
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 201) {
        // Use expand to extract and return the first class model from the list
        final classData = (response.data['data'] as List)
            .expand((data) => [ClassModel.fromMap(data)])
            .first;

        print(classData);

        return classData;
      } else {
        throw Exception('Failed to insert school class: ${response.data}');
      }
    } catch (e) {
      print('Error inserting school class: $e');
      throw e;
    }
  }

  Future<void> updateClass(String newName) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);

      final requestUrl = '$_baseUrl/classes/${currentProfile?.groupId}';

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode(
          {
            'name': newName,
          },
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to update class: ${response.data}');
      }
    } catch (e) {
      print('Error updating class: $e');
      throw e;
    }
  }

  Future<ClassModel> getClassById(String classId) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/classes/$classId';
      print('Request URL: $requestUrl');

      print('Request Headers: $headers');

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to get class: ${response.data}');
      }
    } catch (e) {
      print('Error get class: $e');
      throw e;
    }
  }

  Future<bool> deleteClass(String classId) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/classes/$classId';

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating class: $e');
      return false;
    }
  }

  Future<bool> insertBatchClass(List<String> classes) async {
    try {
      final results = await Future.wait(
        classes.map((className) => insertSchoolClass(className, null)),
      );

      return results.every((result) => result == true);
    } catch (e) {
      print("Error inserting classes: $e");
      return false;
    }
  }

  // Insert personal class
  Future<void> bindRelationship(List<String> profileIds) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final currentClass = await getCurrentClass();

      final response = await _dio.post(
        '$_baseUrl/classes/${currentClass?.id}/rels',
        data: jsonEncode(
          {'profiles': profileIds},
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      print('bind successful: ${response.data}');

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to insert school class: ${response.data}');
      }
    } catch (e) {
      print('Error inserting school class: $e');
      throw e;
    }
  }
}
