import 'dart:convert';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SchoolService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  SchoolService() {
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

  Future<Map<String, List<dynamic>>> getAllSchools() async {
    List<SchoolModel> schools = [];
    List<ProfileModel> schoolProfiles = [];
    try {
      await _initialize();
      final profiles = await getUserProfiles();

      if (profiles.isEmpty) {
        print('Không có profile nào được lưu trong SharedPreferences');
        return {'profiles': [], 'schools': []};
      }

      // Kiểm tra nếu là Kweb thì không cần cookie
      const useCookie = !kIsWeb;  // Kiểm tra isKweb (nếu true thì không dùng cookie)

      // Lấy cookies từ PersistCookieJar nếu không phải là Kweb
      String cookieHeader = '';
      if (useCookie) {
        final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
        if (cookies.isEmpty) {
          throw Exception('No cookies available for authentication');
        }
        cookieHeader = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      }

      // Lặp qua tất cả profiles và lấy thông tin trường
      for (var profile in profiles) {
        // Bỏ qua những profiles không phải là trường
        if (profile.groupType != 0) continue;

        schoolProfiles.add(profile);

        final requestUrl = '$_baseUrl/schools/${profile.groupId}';
        final headers = {
          'Content-Type': 'application/json',
          'Cookie': useCookie ? cookieHeader : '',
          'x-profile-id': profile.id,
        };

        final response = await _dio.get(
          requestUrl,
          options: Options(headers: headers),
        );

        if (response.statusCode == 200) {
          // Thêm trường vào danh sách nếu lấy thành công
          schools.add(SchoolModel.fromMap(response.data['data']));
        } else if (response.statusCode == 404) {
          // Nếu không tìm thấy trường
          print('Không tìm thấy trường với ID profile: ${profile.id}');
          return {'profiles': schoolProfiles, 'schools': []};
        } else {
          // Xử lý lỗi khi lấy thông tin trường
          print('Lỗi khi lấy trường: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
          throw Exception('Failed to fetch school by ID: ${response.data}');
        }
      }

      return {'profiles': schoolProfiles, 'schools': schools};
    } catch (e) {
      // Xử lý lỗi tổng thể
      print('Error fetching school by ID: $e');
      return {'profiles': [], 'schools': []};
    }
  }


  // Thêm trường mới
  Future<void> insertSchool(String name, String address, String phoneNumber,
      String? avatarUrl) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/school-icon.png';

      final response = await _dio.post(
        '$_baseUrl/schools',
        data: jsonEncode(
          {
            'name': name,
            'address': address,
            'phoneNumber': phoneNumber,
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
        return response.data['data'];
      } else {
        throw Exception('Failed to insert school: ${response.data}');
      }
    } catch (e) {
      print('Error inserting school: $e');
      throw e;
    }
  }

  Future<bool> deleteSchool(String schoolId) async {
    try {
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/schools/$schoolId';

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
      print('Error delete school: $e');
      return false;
    }
  }
}
