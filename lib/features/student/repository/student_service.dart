import 'dart:convert';
import 'dart:io';

import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/models/role_model.dart';
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

  Future<bool> insertStudent(String displayName) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

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
            'roles': ['Student']
          },
        ),
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
        // If the student is created successfully, return true
        return true;
      } else {
        throw Exception('Failed to insert student: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting student: ${e.response}');
      throw e;
    }
  }

  Future<bool> deleteStudent(String studentId) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/profiles/$studentId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        // If the student is deleted successfully, return true
        return true;
      } else {
        throw Exception('Failed to delete student: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error deleting student: ${e.response}');
      throw e;
    }
  }

  Future<List<ProfileModel>> getAllStudentInClass() async {
    List<ProfileModel> students = [];

    try {
      await _initialize();

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

      final currentProfile = await getCurrentProfile();

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      String requestUrl;

      if (currentProfile?.groupType == 0) {
        final currentClass = await ClassService().getCurrentClass();
        requestUrl =
            '$_baseUrl/profiles/${currentProfile?.groupType}/${currentProfile?.groupId}';
      } else {
        requestUrl =
            '$_baseUrl/profiles/${currentProfile?.groupType}/${currentProfile?.groupId}';
      }

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
        students = allProfiles
            .where((profile) => profile.roles.contains(studentRoleId))
            .toList();

        return students;
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching student by ID: $e');
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
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();

      final headers = {
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      // Kiểm tra nếu cả `newName` và `file` đều null -> Không làm gì cả
      if (newName == null && file == null) {
        throw Exception('Both newName and file cannot be null');
      }


      // Cập nhật tên nếu `newName` không null
      if (newName != null) {
        final requestUrl = '$_baseUrl/profiles/$studentId';
        final response = await _dio.patch(
          requestUrl,
          data: jsonEncode({'displayName': newName}),
          options: Options(
              headers: {...headers, 'Content-Type': 'application/json'}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update name: ${response.data}');
        } else {
        }
      }

      // Cập nhật ảnh đại diện nếu `file` không null
      if (file != null) {
        await updateAvatar(studentId, file);
      }
    } catch (e) {
      print('Error updating student: $e');
      throw e;
    }
  }
}
