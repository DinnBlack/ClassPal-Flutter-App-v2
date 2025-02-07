import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/models/role_model.dart';
import '../../class/models/class_model.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../models/student_model.dart';

class StudentService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  StudentService() {
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

  // Khôi phục cookie từ SharedPreferences
  Future<void> restoreCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookiesString = prefs.getString('cookies');

    if (cookiesString != null) {
      final cookieList = (jsonDecode(cookiesString) as List).map((cookie) {
        return Cookie(cookie['name'], cookie['value'])
          ..domain = cookie['domain']
          ..path = cookie['path']
          ..expires = cookie['expires'] != null
              ? DateTime.fromMillisecondsSinceEpoch(cookie['expires'])
              : null
          ..httpOnly = cookie['httpOnly']
          ..secure = cookie['secure'];
      }).toList();

      await _cookieJar.saveFromResponse(Uri.parse(_baseUrl), cookieList);
      print('Cookies đã được khôi phục');
    }
  }

// Fetch students by ClassModel
  Future<List<StudentModel>> fetchStudentsByClass(
      ClassModel currentClass) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      return [];
    } catch (e) {
      return [];
    }
  }

  // Insert a new student to personal class
  Future<bool> insertStudent(String displayName) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();

      print(profile);
      print(displayName);

      final requestUrl =
          '$_baseUrl/profiles/${profile?.groupType}/${profile?.groupId}';

      print(requestUrl);

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile?.id,
      };

      print(headers);

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {
            'displayName': displayName,
            'roles': ['Student']
          },
        ),
        options: Options(headers: headers),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to insert student: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting student: ${e.response}');
      throw e;
    }
  }

  Future<List<ProfileModel>> getAllStudentClass() async {
    List<ProfileModel> students = [];

    try {
      await _initialize();

      final classProfile = await ProfileService().getProfileFromSharedPreferences();
      if (classProfile == null) {
        print('Không có profile nào trong SharedPreferences');
        return [];
      }

      // Lấy danh sách vai trò từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? roleJsonList = prefs.getStringList('roles');

      if (roleJsonList == null) {
        print('Không tìm thấy danh sách roles trong SharedPreferences');
        return [];
      }

      List<RoleModel> roles = roleJsonList.map((roleJson) => RoleModel.fromMap(jsonDecode(roleJson))).toList();

      // Tìm role ID của Student
      String? studentRoleId;
      for (var role in roles) {
        if (role.name == "Student") {
          studentRoleId = role.id;
          break;
        }
      }

      if (studentRoleId == null) {
        print('Không tìm thấy role Student');
        return [];
      }



      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/profiles/1/${classProfile.groupId}';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': classProfile.id,
      };

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        List<ProfileModel> allProfiles = data.map((profileData) => ProfileModel.fromMap(profileData)).toList();

        // Lọc danh sách chỉ chứa học sinh
        students = allProfiles.where((profile) => profile.roles.contains(studentRoleId)).toList();

        print(students);
        return students;
      } else {
        print('Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching student by ID: $e');
      return [];
    }
  }
}
