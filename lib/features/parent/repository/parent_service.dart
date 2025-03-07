import 'package:classpal_flutter_app/features/parent/models/parent_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/cookie/token_manager.dart';
import '../../profile/model/profile_model.dart';

class ParentService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  ParentService() {
    TokenManager.initialize();
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

      List<ProfileModel> allProfiles = [];

      for (var parent in parents) {
        try {
          final headers = await buildHeaders(profileId: parent.id);
          final response = await _dio.get(
            '$_baseUrl/profiles/${parent.id}/related',
            options: Options(
              headers: headers, extra: {'withCredentials': true}
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
