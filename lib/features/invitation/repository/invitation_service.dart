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
  Future<bool> sendInvitationMails(
      String role, String profileId, String email) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      print(role);
      print(profileId);
      print(email);

      final response = await _dio.post(
        '$_baseUrl/invitations/mail',
        data: jsonEncode(
          {
            'groupId': currentProfile?.groupId,
            'groupType': currentProfile?.groupType,
            'role': role,
            'profileId': profileId,
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

      print(response.data['data']);

      if (response.statusCode == 201) {
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
}
