import 'dart:convert';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  SchoolService() {
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

  // In SchoolService, fetch profiles from SharedPreferences
  Future<List<ProfileModel>> getProfilesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = prefs.getString('profiles');

    if (profilesJson != null) {
      final List<dynamic> profilesData = jsonDecode(profilesJson);
      return profilesData
          .map((profile) => ProfileModel.fromMap(profile))
          .toList();
    } else {
      return [];
    }
  }

  Future<Map<String, List<dynamic>>> getAllSchools() async {
    List<SchoolModel> schools = [];
    List<ProfileModel> schoolProfiles = [];
    try {
      await _initialize();
      final profiles = await getProfilesFromSharedPreferences();

      if (profiles.isEmpty) {
        print('Không có profile nào được lưu trong SharedPreferences');
        return {'profiles': [], 'schools': []};
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
        if (profile.groupType != 0) {
          continue;
        }

        schoolProfiles.add(profile);

        final requestUrl = '$_baseUrl/schools/${profile.groupId}';

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
          schools.add(SchoolModel.fromMap(response.data['data']));
        } else if (response.statusCode == 404) {
          print('Không tìm thấy trường với ID profile: ${profile.id}');
          return {'profiles': schoolProfiles, 'schools': []};
        } else {
          print(
              'Lỗi khi lấy trường: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
          throw Exception('Failed to fetch school by ID: ${response.data}');
        }
      }
      return {'profiles': schoolProfiles, 'schools': schools};
    } catch (e) {
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

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to insert school: ${response.data}');
      }
    } catch (e) {
      print('Error inserting school: $e');
      throw e;
    }
  }
}
