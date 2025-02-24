import 'dart:io';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';

class StudentService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  StudentService() {
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

  Future<bool> insertStudent(String displayName) async {
    try {
      final currentProfile = await getCurrentProfile();

      var result;

      if (currentProfile!.groupType == 0) {
        result = await insertProfile(displayName, 'Student', 0);
        await ClassService().bindRelationship(result.id);
      } else {
        result = await insertProfile(displayName, 'Student', 1);
      }

      print(result);

      if (result != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error inserting student: $e');
      return false;
    }
  }

  Future<bool> deleteStudent(String studentId) async {
    try {
      return await deleteProfile(studentId);
    } catch (e) {
      print('Error delete student: $e');
      return false;
    }
  }

  Future<List<ProfileModel>?> getStudents() async {
    try {
      final profiles = await getProfilesByGroup(1);

      print(profiles);

      final studentRoleId = await getRoleIdByName('Student');

      if (studentRoleId == null) {
        print("Không tìm thấy role Parent");
        return [];
      }

      // Lọc danh sách các hồ sơ có vai trò là Student
      final studentProfiles = profiles
          ?.where((profile) => profile.roles.contains(studentRoleId))
          .toList();

      return studentProfiles;
    } catch (e) {
      print("Lỗi khi lấy danh sách phụ huynh: $e");
      return [];
    }
  }

  Future<List<ProfileModel>> getAllStudentInGroup(
      List<String> studentIds) async {
    List<ProfileModel> students = [];

    try {
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      // Gọi API cho từng studentId, dùng Future.wait để chạy song song
      students = await Future.wait(studentIds.map((studentId) async {
        final requestUrl = '$_baseUrl/profiles/$studentId';

        try {
          final response = await _dio.get(
            requestUrl,
            options: Options(headers: headers),
          );

          if (response.statusCode == 200) {
            return ProfileModel.fromMap(response.data['data']);
          } else {
            print(
                'Lỗi khi lấy sinh viên $studentId: ${response.statusCode}, ${response.data}');
            return null;
          }
        } catch (e) {
          print('Lỗi khi lấy sinh viên $studentId: $e');
          return null;
        }
      })).then((list) => list.whereType<ProfileModel>().toList());

      return students;
    } catch (e) {
      print('Lỗi khi lấy danh sách sinh viên: $e');
      return [];
    }
  }

  Future<void> updateStudent(
      String studentId, String? newName, File? file) async {
    try {
      if (newName == null && file == null) return;
      if (newName != null) {
        await updateProfile(profileId: studentId, name: newName);
      }
      if (file != null) {
        await updateAvatar(studentId, file);
      }
    } catch (e) {
      print('Error updating student: $e');
      throw e;
    }
  }
}
