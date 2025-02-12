import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/models/role_model.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';

class TeacherService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  TeacherService() {
    _initialize();
  }

  // Khởi tạo PersistCookieJar để lưu trữ cookie
  Future<void> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    _dio.interceptors.add(CookieManager(_cookieJar));
    await restoreCookies();
  }

  Future<bool> insertTeacher(String displayName) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl =
          '$_baseUrl/profiles/${currentProfile?.groupType}/${currentProfile?.groupId}';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {
            'displayName': displayName,
            'roles': ['Teacher']
          },
        ),
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
        print('Success inserting teacher: ${response.data}');
        return true;
      } else {
        throw Exception('Failed to insert teacher: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting teacher: ${e.response}');
      throw e;
    }
  }

  Future<List<ProfileModel>> getAllTeacher() async {
    List<ProfileModel> teachers = [];

    try {
      await _initialize();

      final currentProfile = await getCurrentProfile();

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

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/profiles/0/${currentProfile?.groupId}';
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
