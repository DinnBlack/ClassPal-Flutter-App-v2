import 'dart:convert';

import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:classpal_flutter_app/features/student/repository/student_service.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_model.dart';
import 'package:dio/dio.dart';
import '../../../../../core/config/cookie/token_manager.dart';
import '../../../../profile/model/profile_model.dart';
import '../model/group_with_students_model.dart';

class GroupService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  GroupService() {
    TokenManager.initialize();
  }

  Future<bool> insertGroup(String name, List<String> studentIds) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/parties/${currentProfile?.groupId}';

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {'name': name, 'memberIds': studentIds},
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to insert student: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting student: ${e.response}');
      throw e;
    }
  }

  Future<List<GroupWithStudentsModel>> getAllGroup() async {
    List<GroupWithStudentsModel> groupWithStudentsList = [];

    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/parties/${currentProfile?.groupId}';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;

        for (var groupData in data) {
          GroupModel group = GroupModel.fromMap(groupData);

          // Lấy danh sách sinh viên của nhóm
          List<ProfileModel> students =
              await StudentService().getAllStudentInGroup(group.memberIds);

          // Lưu vào danh sách
          groupWithStudentsList
              .add(GroupWithStudentsModel(group: group, students: students));
        }

        return groupWithStudentsList;
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching groups by ID: $e');
      return [];
    }
  }

  Future<void> updateGroup(GroupWithStudentsModel groupWithStudents,
      String? name, List<String>? studentIds) async {
    try {

      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);

      // Cập nhật tên nhóm nếu có thay đổi
      if (name != null) {
        final requestUrl =
            '$_baseUrl/parties/${currentProfile?.groupId}/${groupWithStudents.group.id}';
        print('Updating group name at URL: $requestUrl');

        final response = await _dio.patch(
          requestUrl,
          data: jsonEncode({'name': name}),
          options: Options(headers: headers, extra: {'withCredentials': true}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update group name: ${response.data}');
        }

        print('Group name updated: ${response.data}');
      }

      if (studentIds != null) {
        final Set<String> initialStudentIds =
            groupWithStudents.students.map((s) => s.id).toSet();
        final Set<String> newStudentIds = studentIds.toSet();
        final List<String> studentsToRemove =
            initialStudentIds.difference(newStudentIds).toList();

        if (studentsToRemove.isNotEmpty) {
          print('Deleting students: $studentsToRemove');
          await deleteStudentInGroup(groupWithStudents.group, studentsToRemove);
        }

        final requestUrl =
            '$_baseUrl/parties/${currentProfile?.groupId}/${groupWithStudents.group.id}/members';
        print('Updating group members at URL: $requestUrl');

        final response = await _dio.patch(
          requestUrl,
          data: jsonEncode({'memberIds': studentIds}),
          options: Options(headers: headers, extra: {'withCredentials': true}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update group members: ${response.data}');
        }

        print('Group members updated: ${response.data}');
      }
    } catch (e) {
      print('Error updating group: $e');
      throw e;
    }
  }

  Future<bool> deleteStudentInGroup(
      GroupModel group, List<String> studentIds) async {
    try {

      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/parties/${currentProfile?.groupId}/${group.id}/members';

      final response = await _dio.delete(
        requestUrl,
        data: jsonEncode({'memberIds': studentIds}),
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete student: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error deleting student: ${e.response}');
      throw e;
    }
  }

  Future<bool> deleteGroup(String groupId) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl =
          '$_baseUrl/parties/${currentProfile?.groupId}/$groupId';

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete group: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error deleting group: ${e.response}');
      throw e;
    }
  }
}
