import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../models/class_model.dart';

class ClassService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  ClassService() {
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
      await _initialize();
      final profiles = await getUserProfiles();

      if (profiles.isEmpty) {
        print('Không có profile nào được lưu trong SharedPreferences');
        return {'profiles': [], 'classes': []};
      }

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      for (var profile in profiles) {
        if (profile.groupType != 1) {
          continue;
        }

        classProfiles.add(profile);

        final requestUrl = '$_baseUrl/classes/${profile.groupId}';
        final headers = {
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
          'x-profile-id': profile.id,
        };

        final response = await _dio.get(
          requestUrl,
          options: Options(headers: headers),
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
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final response = await _dio.get(
        '$_baseUrl/classes/school/${currentProfile?.groupId}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id,
          },
        ),
      );

      print(response.data);

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
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

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
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
        ),
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
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

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
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
        ),
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
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/classes/${currentProfile?.groupId}';
      print('Request URL: $requestUrl');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      print('Request Headers: $headers');

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode(
          {
            'name': newName,
          },
        ),
        options: Options(headers: headers),
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
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/classes/$classId';
      print('Request URL: $requestUrl');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      print('Request Headers: $headers');

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers),
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
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      print(classId);

      final requestUrl = '$_baseUrl/classes/$classId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers),
      );

      print(response.statusCode);
      print(response.data);

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
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final currentClass = await getCurrentClass();

      print(profileIds);
      print(currentClass);

      final response = await _dio.post(
        '$_baseUrl/classes/${currentClass?.id}/rels',
        data: jsonEncode(
          {'profiles': profileIds},
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id,
          },
        ),
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
