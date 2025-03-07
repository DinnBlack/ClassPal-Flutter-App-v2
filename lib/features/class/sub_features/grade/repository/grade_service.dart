import 'dart:convert';
import 'package:classpal_flutter_app/features/class/sub_features/grade/models/grade_model.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/repository/subject_service.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:dio/dio.dart';
import '../../../../../core/config/cookie/token_manager.dart';
import '../models/grade_type_model.dart';

class GradeService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = TokenManager.dio;

  GradeService() {
    TokenManager.initialize();
  }

  Future<bool> insertGrade(String subjectId, String gradeTypeId,
      String studentId, double value, String comment) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/grades/subject/$subjectId';

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
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(
          profileId: currentProfile?.tempId ?? currentProfile?.id);
      var requestUrl = '$_baseUrl/grades/student/$studentId';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/grades/subject/$subjectId';

      final response = await _dio.get(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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

  Future<bool> updateGrade(
      String subjectId, String gradeId, double value, String comment) async {
    try {
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/grades/subject/$subjectId/$gradeId';

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode(
          {
            'value': value,
            'comment': comment,
          },
        ),
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
      final currentProfile = await getCurrentProfile();
      final headers = await buildHeaders(profileId: currentProfile?.id);
      final requestUrl = '$_baseUrl/grades/subject/$subjectId/$gradeId';

      final response = await _dio.delete(
        requestUrl,
        options: Options(headers: headers, extra: {'withCredentials': true}),
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
