import 'dart:convert';
import 'dart:io';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../auth/models/role_model.dart';

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
  Future<void> saveUserProfiles(List<ProfileModel> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profiles');
    final profilesJson =
        jsonEncode(profiles.map((profile) => profile.toMap()).toList());
    await prefs.setString('profiles', profilesJson);
  }

  // Get profiles from SharedPreferences
  Future<List<ProfileModel>> getUserProfiles() async {
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

  Future<ProfileModel?> insertProfile(
      String name, String role, int groupType) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo headers với cookies
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();
      final currentClass = await ClassService().getCurrentClass();

      var responseUrl = '$_baseUrl/profiles/1/${currentClass?.id}';

      if (groupType == 0) {
        responseUrl = '$_baseUrl/profiles/0/${currentProfile?.id}';
      }

      print(responseUrl);
      print(name);
      print(role);

      final response = await _dio.post(
        responseUrl,
        data: jsonEncode(
          {
            'displayName': name,
            'roles': [role]
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
        print('Create profile successfully: ${response.data}');
        final List<dynamic> dataList = response.data['data'];
        return ProfileModel.fromMap(dataList.first);
      } else {
        print('Create profile fail: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print('Failed to create profile: ${e.response?.data}');
      return null;
    }
  }

  Future<bool> insertBatchProfile(
      List<String> names, String role, int groupType) async {
    try {

      // Chạy các yêu cầu song song để cải thiện hiệu suất
      final results = await Future.wait(
        names.map((name) => insertProfile(name, role, groupType)),
      );

      // Kiểm tra nếu có ít nhất một profile tạo thành công
      return results.any((profile) => profile != null);
    } on DioException catch (e) {
      print('Failed to create batch profiles: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> deleteProfile(String profileId) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo headers với cookies
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      print(profileId);

      final response = await _dio.delete(
        '$_baseUrl/profiles/$profileId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id,
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Delete profile successfully: ${response.data}');
        final List<dynamic> dataList = response.data['data'];
        return true;
      } else {
        print('Delete profile fail: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('Failed to delete profile: ${e.response?.data}');
      return true;
    }
  }

  // Hàm lấy thông tin profile của người dùng
  Future<List<ProfileModel>?> getProfilesByGroup(int groupType) async {
    try {
      await _initialize();
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo headers với cookies
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();
      final currentClass = await ClassService().getCurrentClass();

      print('getProfilesByGroup: ${currentClass!.id}');

      var responseUrl = '$_baseUrl/profiles/1/${currentClass?.id}';

      print('responseUrl: $responseUrl');

      if (groupType == 0) {
        responseUrl = '$_baseUrl/profiles/0/${currentClass?.id}';
      }

      final response = await _dio.get(
        responseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id,
          },
        ),
      );

      print('response: ${response.data}');

      if (response.statusCode == 200) {
        var profilesData = response.data['data'] as List;
        List<ProfileModel> profiles = profilesData
            .map((profile) => ProfileModel.fromMap(profile))
            .toList();

        return profiles;
      } else {
        print('Get profiles by group fail: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error fetching profiles by group: $e');
      return null;
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
        await saveUserProfiles(profiles);
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
        await saveUserProfiles(profiles);

        return profiles;
      } else {
        print(
            'Failed to fetch profile: ${response.statusCode} - ${response.statusMessage}');
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

  Future<List<ProfileModel>> getRelatedToProfile(String parentId) async {
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
        '$_baseUrl/profiles/$parentId/related',
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

        final studentRoleId = await getRoleIdByName('Student');

        // Chuyển profileData thành danh sách các ProfileModel
        List<ProfileModel> profiles = profileData
            .map<ProfileModel>((data) => ProfileModel.fromMap(data))
            .toList();

        // Lọc danh sách các ProfileModel có chứa studentRoleId trong roles
        List<ProfileModel> filteredProfiles = profiles
            .where(
              (profile) => profile.roles.contains(studentRoleId),
            )
            .toList();

        return filteredProfiles;
      } else {
        throw Exception('Failed to fetch profile related: ${response.data}');
      }
    } catch (e) {
      print('Error fetching profile related: $e');
      return [];
    }
  }

  // Hàm lấy thông tin profile của người dùng
  Future<ProfileModel?> addChildForParent(
      String parentId, String childId) async {
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

      final response = await _dio.post(
        '$_baseUrl/profiles/$parentId/rels',
        data: jsonEncode({
          'childIds': [childId]
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
            'x-profile-id': currentProfile?.id
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        var profileData = response.data['data'];

        ProfileModel profile = ProfileModel.fromMap(profileData);

        return profile;
      } else {
        throw Exception('Failed to add profile: ${response.data}');
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
        await saveUserProfiles(profiles);
        return profiles;
      } else {
        throw Exception('Failed to fetch profiles: ${response.data}');
      }
    } catch (e) {
      print('Error fetching profile by roles: $e');
      return [];
    }
  }

  Future<String?> getRoleIdByName(String roleName) async {
    // Lấy danh sách vai trò từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? roleJsonList = prefs.getStringList('roles');

    if (roleJsonList == null) {
      print('Không tìm thấy danh sách roles trong SharedPreferences');
      return null;
    }

    // Chuyển đổi danh sách JSON thành danh sách RoleModel
    List<RoleModel> roles = roleJsonList
        .map((roleJson) => RoleModel.fromMap(jsonDecode(roleJson)))
        .toList();

    // Tìm role ID theo roleName
    for (var role in roles) {
      if (role.name == roleName) {
        return role.id;
      }
    }

    print('Không tìm thấy role $roleName');
    return null;
  }

  Future<void> updateProfile({
    required String profileId,
    String? name,
    List<String>? roles,
  }) async {
    try {
      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();
      if (currentProfile == null || currentProfile.id.isEmpty) {
        throw Exception('Failed to retrieve current profile');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile.id,
      };

      final requestUrl = '$_baseUrl/profiles/$profileId';

      final Map<String, dynamic> data = {};
      if (name != null) data['displayName'] = name;
      if (roles != null) data['roles'] = roles;

      if (data.isEmpty) {
        throw Exception('No update data provided');
      }

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode(data),
        options: Options(headers: headers),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to update profile: ${response.statusMessage ?? response.data}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw e;
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

      // Kiểm tra file có tồn tại không
      if (!imageFile.existsSync()) {
        throw Exception('File không tồn tại: $fileName');
      }
      MultipartFile file = await MultipartFile.fromFile(imageFile.path,
          filename: fileName, contentType: MediaType("image", "jpeg"));

      // Tạo FormData chứa file ảnh
      FormData formData = FormData.fromMap({"image": file});

      // Gửi yêu cầu API
      final response = await _dio.patch(
        requestUrl,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        print("Avatar cập nhật thành công!");
        return response.data['data'];
      } else {
        throw Exception('Lỗi cập nhật avatar: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Lỗi khi gửi yêu cầu cập nhật avatar: ${e.response?.data}');
    }
  }
}
