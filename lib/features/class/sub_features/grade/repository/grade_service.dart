import 'dart:convert';

import 'package:classpal_flutter_app/features/class/sub_features/grade/models/grade_model.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/repository/subject_service.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/grade_type_model.dart';

class GradeService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  GradeService() {
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

  Future<bool> insertGrade(String subjectId, String gradeTypeId,
      String studentId, double value, String comment) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/grades/subject/$subjectId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode(
          {
            'studentId': studentId,
            'gradeTypeId': gradeTypeId,
            'value': value,
            'comment': comment,
          },
        ),
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to insert grade: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error inserting grade: ${e.response}');
      throw e;
    }
  }

  Future<List<GradeModel>> getGradesByStudentId(String studentId) async {
    try {
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      var requestUrl = '$_baseUrl/grades/student/$studentId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.tempId ?? currentProfile?.id,
      };

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;

        List<GradeModel> studentGrades =
            await Future.wait(data.map((grade) async {
          String subjectName = '';
          String gradeTypeName = '';

          // Fetch subject and grade type name
          try {
            final subject =
                await SubjectService().getSubjectById(grade['subjectId']);
            if (subject != null) {
              subjectName = subject.name;
              final gradeType = subject.gradeTypes.firstWhere(
                (g) => g.id == grade['gradeTypeId'],
                orElse: () => const GradeTypeModel(id: '', name: 'Unknown'),
              );
              gradeTypeName = gradeType.name;
            }
          } catch (e) {
            print('Lỗi khi lấy subject hoặc gradeType: $e');
          }

          return GradeModel.fromMap(grade).copyWith(
            subjectName: subjectName,
            gradeTypeName: gradeTypeName,
          );
        }).toList());

        return studentGrades;
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching subject: ${e.response!.data}');
      return [];
    }
  }

  Future<List<GradeModel>> getGradesBySubjectId(String subjectId) async {
    try {
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/grades/subject/$subjectId';
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;

        List<GradeModel> grades = await Future.wait(data.map((grade) async {
          String subjectName = '';
          String gradeTypeName = '';
          String studentName = '';

          // Fetch subject and grade type name
          try {
            final subject =
                await SubjectService().getSubjectById(grade['subjectId']);
            final student =
                await ProfileService().getProfileById(grade['studentId']);
            print(student);
            if (subject != null) {
              subjectName = subject.name;
              final gradeType = subject.gradeTypes.firstWhere(
                (g) => g.id == grade['gradeTypeId'],
                orElse: () => const GradeTypeModel(id: '', name: 'Unknown'),
              );
              gradeTypeName = gradeType.name;
            }
            if (student != null) {
              studentName = student.displayName;
            }
          } catch (e) {
            print('Lỗi khi lấy subject hoặc gradeType: $e');
          }

          return GradeModel.fromMap(grade).copyWith(
              subjectName: subjectName,
              gradeTypeName: gradeTypeName,
              studentName: studentName);
        }).toList());

        return grades;
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching grade subject: $e');
      return [];
    }
  }

  Future<bool> updateGrade(String subjectId, String gradeId, double value, String comment) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/grades/subject/$subjectId/$gradeId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode(
          {
            'value': value,
            'comment': comment,
          },
        ),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update grade: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error updating grade: ${e.response}');
      throw e;
    }
  }

  Future<bool> deleteGrade(String subjectId, String gradeId) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/grades/subject/$subjectId/$gradeId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete grade: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error delete grade: ${e.response}');
      throw e;
    }
  }
}
