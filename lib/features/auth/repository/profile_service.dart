import 'dart:convert';
import 'package:classpal_flutter_app/features/auth/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  ProfileService() {
    _initialize();
  }

  // Khởi tạo PersistCookieJar để lưu trữ cookie
  Future<void> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Restore cookies when initializing
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

  // Lưu List<ProfileModel> vào SharedPreferences
  Future<void> saveProfilesToSharedPreferences(List<ProfileModel> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = jsonEncode(profiles.map((profile) => profile.toMap()).toList());
    print(profilesJson);
    await prefs.setString('profiles', profilesJson);
    print('Profiles đã được lưu');
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

  // Hàm lấy thông tin profile của người dùng
  Future<List<ProfileModel>> getProfileByUserId() async {
    try {
      // Lấy danh sách cookies đã được khôi phục
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));

      // Đảm bảo cookies đã có trước khi gửi yêu cầu
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo headers với cookies
      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final response = await _dio.get(
        '$_baseUrl/profiles/me',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        var profilesData = response.data['data'] as List;

        List<ProfileModel> profiles = profilesData
            .map((profile) => ProfileModel.fromMap(profile))
            .toList();

        print(profiles[0].id);

        // Lưu profiles vào SharedPreferences
        await saveProfilesToSharedPreferences(profiles);
        List<ProfileModel> profilesPref = await getProfilesFromSharedPreferences();

        print(profilesPref[0].id);

        return profiles;
      } else {
        throw Exception('Failed to fetch profile: ${response.data}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return [];
    }
  }

}
