import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import '../../profile/repository/profile_service.dart';

class InvitationService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  InvitationService() {
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

  // Thêm trường mới
  Future<bool> sendInvitationMailForParent(
      String name, String email, String studentId) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      print(name);
      print(email);

      final parentProfile = await insertProfile(email, 'Parent', 1);

      await addChildForParent(parentProfile!.id, studentId);

      final response = await _dio.post(
        '$_baseUrl/invitations/mail',
        data: jsonEncode(
          {
            'groupId': currentProfile?.groupId,
            'groupType': currentProfile?.groupType,
            'role': 'Parent',
            'profileId': parentProfile.id,
            'emails': [email],
            'expireMinutes': 1440
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Success ${response.data['data']}');
        return true;
      } else {
        print('Failed to send mail: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('Error send mail: ${e.response?.data}');
      return false;
    }
  }

  // Thêm trường mới
  Future<bool> sendInvitationMailForTeacher(String name, String email) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      print(name);
      print(email);

      final teacherProfile = await insertProfile(name, 'Teacher', 1);

      final response = await _dio.post(
        '$_baseUrl/invitations/mail',
        data: jsonEncode(
          {
            'groupId': currentProfile?.groupId,
            'groupType': currentProfile?.groupType,
            'role': 'Teacher',
            'profileId': teacherProfile?.id,
            'emails': [email],
            'expireMinutes': 1440
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Success ${response.data['data']}');
        return true;
      } else {
        print('Failed to send mail: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('Error send mail: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> acceptMailInvitation(String invitationId) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();
      final response = await _dio.post(
        '$_baseUrl/invitations/mail/accept/$invitationId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id,
          },
        ),
      );

      print(response.data);

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting group code: $e');
      return false;
    }
  }

  Future<String?> generateGroupCode(String groupId, int groupType,
      String newProfileRole, int expireMinutes) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final currentProfile = await getCurrentProfile();

      final response = await _dio.post(
        '$_baseUrl/invitations/code',
        data: jsonEncode(
          {
            'groupId': groupId,
            'groupType': groupType,
            'newProfileRole': newProfileRole,
            'expireMinutes': expireMinutes,
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id,
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data['data'];
      } else {
        print('Failed to generate group code: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error generating group code: $e');
      return null;
    }
  }

  Future<bool> submitGroupCode(String code) async {
    try {
      await _initialize();
      final response = await _dio.post(
        '$_baseUrl/invitations/code/$code',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting group code: $e');
      return false;
    }
  }

  Future<bool> removeGroupCode(String code) async {
    try {
      await _initialize();
      final response = await _dio.delete(
        '$_baseUrl/invitations/code/$code',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing group code: $e');
      return false;
    }
  }

  Future<bool> removeInvitation(String email) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();
      final response = await _dio.delete(
        '$_baseUrl/invitations/mail',
        data: jsonEncode({
          'email': email,
          'groupType': currentProfile?.groupType,
          'groupId': currentProfile?.groupId,
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing invitation: $e');
      return false;
    }
  }
}
