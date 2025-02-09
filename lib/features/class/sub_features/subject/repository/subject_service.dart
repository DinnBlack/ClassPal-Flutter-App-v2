import 'dart:convert';

import 'package:classpal_flutter_app/features/class/sub_features/grade/models/grade_type_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../profile/repository/profile_service.dart';
import '../models/subject_model.dart';

class SubjectService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  SubjectService() {
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

  Future<List<SubjectModel>> getAllSubject() async {
    try {
      await _initialize();

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) {
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

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/subjects/${profile.groupId}';
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
        final data = response.data['data'] as List;
        print(data);
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
      await _initialize();

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) {
        print('Không có profile nào trong SharedPreferences');
        return null;
      }

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/subjects/${profile.groupId}/$subjectId';
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
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();

      final requestUrl = '$_baseUrl/subjects/${profile?.groupId}';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile?.id,
      };

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {'name': name, 'gradeTypes': gradeTypes},
        ),
        options: Options(headers: headers),
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
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) throw Exception('Profile not found');

      final requestUrl = '$_baseUrl/subjects/${profile.groupId}/${subject.id}';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile.id,
      };

      print(subject);
      print(name);
      print(gradeTypes);

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
          options: Options(headers: headers),
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
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) throw Exception('Profile not found');

      final requestUrl =
          '$_baseUrl/subjects/${profile.groupId}/$subjectId/grade';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile.id,
      };

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode({'gradeTypes': gradeTypes}),
        options: Options(headers: headers),
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
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) throw Exception('Profile not found');

      final requestUrl =
          '$_baseUrl/subjects/${profile.groupId}/$subjectId/grade';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile.id,
      };

      final response = await _dio.delete(
        requestUrl,
        data: jsonEncode({'gradeTypes': gradeTypeIds}),
        options: Options(headers: headers),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting grade types: $e');
      throw e;
    }
  }

  Future<bool> deleteSubject(String subjectId) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();
      if (profile == null) throw Exception('Profile not found');

      final requestUrl = '$_baseUrl/subjects/${profile.groupId}/$subjectId';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile.id,
      };

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting grade types: $e');
      throw e;
    }
  }
}
