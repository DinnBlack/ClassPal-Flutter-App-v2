import 'dart:convert';
import 'dart:io';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/config/cookie/token_manager.dart';
import '../../auth/models/role_model.dart';

class ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  ProfileService() {
    TokenManager.initialize();
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

  Future<Map<String, String>> buildHeaders({String? profileId, String? contentType}) async {
    String? cookieHeader;
    if (!kIsWeb) {
      cookieHeader = await TokenManager.getCookies();
    }
    print("Cookie Header: $cookieHeader");

    return {
      'Content-Type': contentType ?? 'application/json',
      if (!kIsWeb && cookieHeader != null) 'Cookie': cookieHeader,
      if (profileId != null) 'x-profile-id': profileId,
    };
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
      final currentProfile = await getCurrentProfile();
      final currentClass = await ClassService().getCurrentClass();

      if (currentProfile == null || currentClass == null) {
        throw Exception('Current profile or class not found');
      }

      final responseUrl = '$_baseUrl/profiles/$groupType/${currentClass.id}';
      final headers = await buildHeaders(profileId: currentProfile.id);

      final response = await _dio.post(
        responseUrl,
        data: jsonEncode({
          'displayName': name,
          'roles': [role]
        }),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 201) {
        return ProfileModel.fromMap(response.data['data'].first);
      }
      print('Create profile failed: ${response.data}');
      return null;
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
      final headers = await buildHeaders();
      final response = await _dio.delete(
        '$_baseUrl/profiles/$profileId',
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error deleting profile: $e');
      return false;
    }
  }

  Future<List<ProfileModel>?> getProfilesByGroup(int groupType) async {
    try {
      final currentProfile = await getCurrentProfile();
      final currentClass = await ClassService().getCurrentClass();
      if (currentClass == null) {
        throw Exception('No class found for the current user');
      }

      final responseUrl = '$_baseUrl/profiles/$groupType/${currentClass.id}';
      final headers = await buildHeaders(profileId: currentProfile?.id);

      print(1);

      final response =
          await _dio.get(responseUrl, options: Options(headers: headers, extra: {'withCredentials': true}));
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((profile) => ProfileModel.fromMap(profile))
            .toList();
      }
      print('Get profiles by group failed: ${response.data}');
      return null;
    } on DioException catch (e) {
      print('Error fetching profiles by group: ${e.response?.data}');
      return null;
    }
  }

  Future<List<ProfileModel>> getProfileByUser() async {
    try {
      final headers = await buildHeaders();
      final response = await _dio.get(
        '$_baseUrl/profiles/me',
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        final profiles = (response.data['data'] as List)
            .map((profile) => ProfileModel.fromMap(profile))
            .toList();
        await saveUserProfiles(profiles);
        return profiles;
      } else {
        print(
            'Failed to fetch profile: ${response.statusCode} - ${response.data}');
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return [];
    }
  }

  Future<List<ProfileModel>> getProfilesByRole(List<String> roles) async {
    try {
      final headers = await buildHeaders();

      print(headers);

      // Kiểm tra nếu danh sách roles rỗng
      if (roles.isEmpty) {
        print('No roles provided, returning empty list.');
        return [];
      }

      // Tạo query từ danh sách roles
      final rolesQuery = roles.map((role) => 'roles=$role').join('&');
      final url = '$_baseUrl/profiles/me?$rolesQuery';

      print(url);

      // Gửi request GET
      final response = await _dio.get(url,
          options: Options(headers: headers, extra: {'withCredentials': true}));

      // Kiểm tra phản hồi từ server
      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data is List) {
          final profiles =
              data.map((profile) => ProfileModel.fromMap(profile)).toList();

          // Lưu profile vào SharedPreferences
          await saveUserProfiles(profiles);
          return profiles;
        } else {
          print('Unexpected response format: $data');
          throw Exception('Unexpected response format');
        }
      } else {
        print(
            'Failed to fetch profiles: ${response.statusCode} - ${response.data}');
        throw Exception('Failed to fetch profiles: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error fetching profiles by role: ${e.response}');
      return [];
    }
  }

  Future<ProfileModel?> getProfileById(String id) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(
          profileId: currentProfile?.tempId ?? currentProfile?.id);

      final response = await _dio.get(
        '$_baseUrl/profiles/$id',
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final response = await _dio.get(
        '$_baseUrl/profiles/$parentId/related',
        options: Options(headers: headers, extra: {'withCredentials': true}),
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

  Future<bool> addChildForParent(String parentId, String childId) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);

      final response = await _dio.post(
        '$_baseUrl/profiles/$parentId/rels',
        data: jsonEncode({
          'childIds': [childId]
        }),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error adding child for parent: $e');
      return false;
    }
  }

// Fetch profiles by role(s) from the API
  Future<List<ProfileModel>> getProfileByRoles(List<String> roles) async {
    try {
      final headers = await buildHeaders();
      // Construct the roles query parameters
      String rolesQuery = roles.map((role) => 'roles=$role').join('&');
      final requestUrl = '$_baseUrl/profiles/me?$rolesQuery';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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

  // Hàm cập nhật thông tin profile
  Future<void> updateProfile({
    required String profileId,
    String? name,
    List<String>? roles,
  }) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);

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
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      // Lấy thông tin profile hiện tại
      final currentProfile = await ProfileService().getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/profiles/$studentId/avatar';
      List<String> parts = imageFile.path.split("/");
      String fileName = parts.last.replaceAll("'", "");

      // Kiểm tra nếu file tồn tại
      if (!imageFile.existsSync()) {
        throw Exception('File không tồn tại: $fileName');
      }

      MultipartFile file = await MultipartFile.fromFile(imageFile.path,
          filename: fileName, contentType: MediaType("image", "jpeg"));

      // Tạo FormData với file ảnh
      FormData formData = FormData.fromMap({"image": file});

      // Gửi yêu cầu API
      final response = await _dio.patch(
        requestUrl,
        data: formData,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
