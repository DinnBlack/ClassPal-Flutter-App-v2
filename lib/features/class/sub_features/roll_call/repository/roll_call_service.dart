import 'dart:convert';
import 'package:classpal_flutter_app/features/class/sub_features/roll_call/models/roll_call_entry_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../profile/repository/profile_service.dart';
import '../models/roll_call_session_model.dart';

class RollCallService extends ProfileService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  RollCallService() {
    _initialize();
  }

  Future<void> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    _dio.interceptors.add(CookieManager(_cookieJar));
    await restoreCookies();
  }

  /// **Tạo điểm danh cho lớp**
  Future<bool> createRollCall(String date,
      List<Map<String, int>> studentsRollCall) async {
    try {
      final rollCallSessionId = await createRollCallSession(date);

      print('session id vua tao: $rollCallSessionId');

      if (rollCallSessionId == null) {
        return false;
      }

      if (rollCallSessionId == null) {
        throw Exception('Không thể tạo phiên điểm danh.');
      }

      for (var student in studentsRollCall) {
        for (var entry in student.entries) {
          final profileId = entry.key;
          final status = entry.value;
          await createRollCallEntry(rollCallSessionId, profileId, status);
        }
      }

      return true;
    } catch (e) {
      print('Error in create roll call: $e');
      return false;
    }
  }

  /// **Tạo phiên điểm danh**
  Future<String?> createRollCallSession(String date) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final currentProfile = await getCurrentProfile();

      final requestUrl = '$_baseUrl/rollcall/class/${currentProfile?.groupId}';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode({'date': date}),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return response.data['data']['_id'];
      } else {
        throw Exception('Failed to create roll call session: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error create roll call session: ${e.response}');
      return null;
    }
  }

  /// **Thêm trạng thái điểm danh cho từng học sinh**
  Future<bool> createRollCallEntry(String rollCallSessionId, String profileId,
      int status) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/rollcall/$rollCallSessionId';

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': currentProfile?.id,
      };

      String statusString;
      if (status == 0) {
        statusString = 'present';
      } else if (status == 1) {
        statusString = 'absent';
      } else if (status == 2) {
        statusString = 'late';
      } else {
        throw Exception('Invalid status value: $status');
      }

      final response = await _dio.post(
        requestUrl,
        data: jsonEncode({
          'profileId': profileId,
          'status': statusString,
        }),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to create roll call entry: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error create roll call entry: ${e.response}');
      return false;
    }
  }

  Future<List<RollCallEntryModel>> getRollCallEntriesBySessionId(
      String rollCallSessionId) async {
    try {
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/rollcall/$rollCallSessionId';
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
        final List<dynamic> data = response.data['data'] as List<dynamic>;

        return data.map((json) => RollCallEntryModel.fromMap(json)).toList();
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response
                .statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy điểm danh theo ID phiên: $e');
      return [];
    }
  }

  Future<List<RollCallSessionModel>> getRollCallSession() async {
    try {
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/rollcall/class/${currentProfile?.groupId}';
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
        final List<dynamic> data = response.data['data'] as List<dynamic>;

        return data.map((json) => RollCallSessionModel.fromMap(json)).toList();
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response
                .statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy các dữ liệu điểm danh: $e');
      return [];
    }
  }

  Future<List<RollCallSessionModel>> getRollCallSessionsByDateRange(
      String startDate, String endDate) async {
    try {
      await _initialize();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl =
          '$_baseUrl/rollcall/class/${currentProfile
          ?.groupId}?startDate=$startDate&endDate=$endDate';
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
        final List<dynamic> data = response.data['data'] as List<dynamic>;

        return data.map((json) => RollCallSessionModel.fromMap(json)).toList();
      } else {
        print(
            'Lỗi khi lấy dữ liệu: Mã lỗi ${response
                .statusCode}, Thông báo: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy các dữ liệu điểm danh: $e');
      return [];
    }
  }

  /// **Lấy danh sách phiên điểm danh theo từng học sinh**
  Future<List<RollCallEntryModel>> getRollCallEntriesBySessionIdsByDateRange(
      String startDate, String endDate) async {
    try {
      final rollCallSessions =
      await getRollCallSessionsByDateRange(startDate, endDate);

      final rollCallSessionIds =
      rollCallSessions.map((session) => session.id).toList();

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Lấy danh sách điểm danh từ các phiên điểm danh
      final results = await Future.wait(
        rollCallSessionIds.map((id) => getRollCallEntriesBySessionId(id)),
      );

      final allEntries = results.expand((entries) => entries).toList();

      // Lấy tên học sinh và cập nhật vào danh sách
      List<RollCallEntryModel> updatedEntries = await Future.wait(
        allEntries.map((entry) async {
          final studentProfile = await getProfileById(entry.profileId);
          return entry.copyWith(studentName: studentProfile?.displayName);
        }),
      );

      print(updatedEntries);

      return updatedEntries;
    } catch (e) {
      print(
          'Lỗi khi lấy dữ liệu điểm danh theo từng học sinh theo khoảng ngày: $e');
      return [];
    }
  }

  Future<bool> deleteRollCallSession(String rollCallSessionId) async {
    try {
      await _initialize();

      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final currentProfile = await getCurrentProfile();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final requestUrl = '$_baseUrl/rollcall/$rollCallSessionId';

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
        print(response.data);
        return true;
      } else {
        throw Exception('Failed to delete session: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error deleting session: ${e.response}');
      throw e;
    }
  }
}
