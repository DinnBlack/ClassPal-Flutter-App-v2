import 'dart:convert';
import 'dart:io';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  ProfileService() {
    _initialize();
  }

  // Lưu profile vào Shared Preferences
  Future<void> saveCurrentProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(profile.toMap());
    await prefs.setString('profile', profileJson);
  }

  // Lấy profile từ Shared Preferences
  Future<ProfileModel?> getCurrentProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('profile');

    if (profileJson != null) {
      return ProfileModel.fromMap(jsonDecode(profileJson));
    } else {
      return null;
    }
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
  Future<void> saveProfilesToSharedPreferences(
      List<ProfileModel> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profiles');
    final profilesJson =
        jsonEncode(profiles.map((profile) => profile.toMap()).toList());
    await prefs.setString('profiles', profilesJson);
  }

  // Get profiles from SharedPreferences
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
  Future<List<ProfileModel>> getProfileByUser() async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
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

        // Lưu profiles vào SharedPreferences
        await saveProfilesToSharedPreferences(profiles);
        return profiles;
      } else {
        throw Exception('Failed to fetch profile: ${response.data}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return [];
    }
  }

  Future<List<ProfileModel>> getProfilesByRole(List<String> roles) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        print('No cookies available for authentication');
        return [];
      }

      // Tạo headers với cookies
      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      // Xây dựng query string cho danh sách roles
      final rolesQuery = roles.map((role) => 'roles=$role').join('&');
      final url = '$_baseUrl/profiles/me?$rolesQuery';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null || !response.data.containsKey('data')) {
          print("Response data is invalid: ${response.data}");
          return [];
        }

        var profilesData = response.data['data'] as List;

        List<ProfileModel> profiles = profilesData
            .map((profile) => ProfileModel.fromMap(profile))
            .toList();

        // Lưu profiles vào SharedPreferences
        await saveProfilesToSharedPreferences(profiles);

        return profiles;
      } else {
        print('Failed to fetch profile: ${response.statusCode} - ${response.statusMessage}');
        return [];
      }
    } catch (e, stacktrace) {
      print('Error fetching profile: $e');
      print(stacktrace);
      return [];
    }
  }


  // Hàm lấy thông tin profile của người dùng
  Future<ProfileModel?> getProfileById(String id) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      // Tạo headers với cookies
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final response = await _dio.get(
        '$_baseUrl/profiles/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id
          },
        ),
      );

      if (response.statusCode == 200) {
        var profileData = response.data['data'];

        ProfileModel profile = ProfileModel.fromMap(profileData);

        return profile;
      } else {
        throw Exception('Failed to fetch profile: ${response.data}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

// Fetch profiles by role(s) from the API
  Future<List<ProfileModel>> getProfileByRoles(List<String> roles) async {
    try {
      // Load cookies that were restored earlier
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));

      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Construct the roles query parameters
      String rolesQuery = roles.map((role) => 'roles=$role').join('&');
      final requestUrl = '$_baseUrl/profiles/me?$rolesQuery';

      // Create headers with cookies
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final response = await _dio.get(
        requestUrl,
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

        // Save profiles to SharedPreferences
        await saveProfilesToSharedPreferences(profiles);
        return profiles;
      } else {
        throw Exception('Failed to fetch profiles: ${response.data}');
      }
    } catch (e) {
      print('Error fetching profile by roles: $e');
      return [];
    }
  }

  Future<void> updateAvatar(String studentId, File imageFile) async {
    try {
      // Lấy cookies từ trình quản lý CookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo chuỗi cookie để gửi trong header
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await ProfileService().getCurrentProfile();
      if (currentProfile == null) throw Exception('Profile not found');

      final requestUrl = '$_baseUrl/profiles/$studentId/avatar';
      final headers = {
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile.id,
        'Content-Type':
            "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
      };

      List<String> parts = imageFile.path.split("/");
      String fileName = parts.last.replaceAll("'", "");

      print('Response imageFile: $fileName');
      print('Response requestUrl: $requestUrl');

      // Kiểm tra file có tồn tại không
      if (!imageFile.existsSync()) {
        throw Exception('File không tồn tại: $fileName');
      }
      MultipartFile file = await MultipartFile.fromFile(imageFile.path,
          filename: fileName, contentType: MediaType("image", "jpeg"));

      // Tạo FormData chứa file ảnh
      FormData formData = FormData.fromMap({"image": file});

      print(formData.fields);

      print('Response headers: $headers');

      // Gửi yêu cầu API
      final response = await _dio.patch(
        requestUrl,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        print("Avatar cập nhật thành công!");
        return response.data['data'];
      } else {
        throw Exception('Lỗi cập nhật avatar: ${response.data}');
      }
    } on DioException catch (e) {
      // print(e.response?.headers);
      print(e.response?.requestOptions.data);
      print(e.response?.data);
      print(e.response?.statusCode);
      throw Exception(
          'Lỗi khi gửi yêu cầu cập nhật avatar: ${e.response?.data}');
    }
  }
}
