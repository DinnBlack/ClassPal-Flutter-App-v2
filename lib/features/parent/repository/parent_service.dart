import 'package:classpal_flutter_app/features/parent/models/parent_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../profile/model/profile_model.dart';

class ParentService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  ParentService() {
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

  Future<List<ParentInvitationModel>> getParents() async {
    try {
      // Lấy danh sách hồ sơ
      final profiles = await getProfilesByGroup(1);
      print('Class Profiles: $profiles');

      // id parent
      final parentRoleId = await getRoleIdByName('Parent');
      print('ParentId: $parentRoleId');

      // Lấy danh sách phụ huynh
      final parents = profiles
          ?.where((profile) => profile.roles.contains(parentRoleId))
          .toList();
      print('Parent Profile: $parents');

      // id student
      final studentRoleId = await getRoleIdByName('Student');
      print('StudentId: $studentRoleId');

      // Lấy danh sách students
      final students = profiles
          ?.where((profile) => profile.roles.contains(studentRoleId))
          .toList();
      print('Student Profile: $students');

      // Tạo danh sách mời phụ huynh
      List<ParentInvitationModel> parentsInvitation = [];

      // Duyệt qua các phụ huynh và kiểm tra thông tin phụ huynh của học sinh
      for (var parent in parents!) {
        final relatedProfile = await getRelatedToProfile(parent.id);

        print(relatedProfile);

        if (relatedProfile.isNotEmpty) {
          // Lấy thông tin học sinh có phụ huynh
          final student = relatedProfile.singleWhere(
            (profile) => profile.roles.contains(studentRoleId),
          );

          print(student);

          parentsInvitation.add(ParentInvitationModel(
            email: parent.displayName,
            studentName: student.displayName,
            studentId: student.id,
            parentName: parent.displayName,
            parentId: parent.id,
            invitationStatus: parent.userId != null ? 'connected' : 'pending',
          ));
        }
      }

      print('Step 1: $parentsInvitation');

      // Kiểm tra các học sinh không có phụ huynh
      for (var student in students!) {
        // Kiểm tra nếu học sinh chưa có phụ huynh trong danh sách
        final hasParent = parentsInvitation
            .any((invitation) => invitation.studentId == student.id);

        if (!hasParent) {
          // Thêm học sinh vào danh sách với trạng thái 'disconnected'
          parentsInvitation.add(ParentInvitationModel(
            email: null,
            studentName: student.displayName,
            studentId: student.id,
            parentName: null,
            parentId: null,
            invitationStatus: 'disconnected',
          ));
        }
      }

      print('Step 2: $parentsInvitation');

      return parentsInvitation;
    } catch (e) {
      print("Lỗi khi lấy danh sách phụ huynh: $e");
      return [];
    }
  }

// Lưu parentId vào SharedPreferences
  Future<void> saveParentId(String parentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parentId', parentId);
  }

// Lấy parentId từ SharedPreferences
  Future<String?> getParentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('parentId'); // Trả về chuỗi trực tiếp
  }

  Future<List<ProfileModel>> getChildren() async {
    try {
      final parents = await getUserProfiles();
      print(parents);

      List<ProfileModel> allProfiles = [];

      for (var parent in parents) {
        print(parent);
        try {
          await _initialize();
          final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
          if (cookies.isEmpty) {
            throw Exception('No cookies available for authentication');
          }

          print(parent.id);

          // Tạo headers với cookies
          final cookieHeader = cookies
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; ');

          final response = await _dio.get(
            '$_baseUrl/profiles/${parent.id}/related',
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Cookie': cookieHeader,
                'x-profile-id': parent.id
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
                .where((profile) => profile.roles.contains(studentRoleId))
                .map((profile) =>
                    profile.copyWith(tempId: parent.id)) // Chỉ thay đổi tempId
                .toList();

            allProfiles.addAll(filteredProfiles);
          } else {
            print('Failed to fetch profile related: ${response.data}');
          }
        } on DioException catch (e) {
          print('Error fetching profile related: ${e.response?.data}');
        }
      }

      return allProfiles;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteParent(String parentId) async {
    try {
      return await deleteProfile(parentId);
    } catch (e) {
      print('Error delete parent: $e');
      return false;
    }
  }
}
