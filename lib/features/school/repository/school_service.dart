import 'dart:convert';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:dio/dio.dart';

import '../../../core/config/cookie/token_manager.dart';

class SchoolService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  SchoolService() {
    TokenManager.initialize();
  }

  Future<Map<String, List<dynamic>>> getAllSchools() async {
    List<SchoolModel> schools = [];
    List<ProfileModel> schoolProfiles = [];
    try {
      final profiles = await getUserProfiles();

      // Lặp qua tất cả profiles và lấy thông tin trường
      for (var profile in profiles) {
        // Bỏ qua những profiles không phải là trường
        if (profile.groupType != 0) continue;

        schoolProfiles.add(profile);
        final headers = await buildHeaders(profileId: profile.id);
        final requestUrl = '$_baseUrl/schools/${profile.groupId}';

        final response = await _dio.get(
          requestUrl,
          options: Options(headers: headers, extra: {'withCredentials': true}),
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
          print(
              'Lỗi khi lấy trường: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
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
      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/school-icon.png';
      final headers = await buildHeaders();
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
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/schools/$schoolId';

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
