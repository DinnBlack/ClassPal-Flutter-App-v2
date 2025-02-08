import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../models/class_model.dart';

class ClassService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  ClassService() {
    _initialize();
  }

  Future<void> saveClassToSharedPreferences(ClassModel currentClass) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('class')) {
      await prefs.remove('class');
    }
    final classJson = jsonEncode(currentClass.toMap());
    await prefs.setString('class', classJson);
  }

  // Lấy class từ Shared Preferences
  Future<ClassModel?> getClassFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final classJson = prefs.getString('class');

    if (classJson != null) {
      return ClassModel.fromMap(jsonDecode(classJson));
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

  // In SchoolService, fetch profiles from SharedPreferences
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

  Future<void> preloadClasses() async {
    try {
      final data = await getAllPersonalClass();
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode({
        'profiles': (data['profiles'])?.map((e) => e.toMap()).toList() ?? [],
        'classes': (data['classes'])?.map((e) => e.toMap()).toList() ?? [],
      });

      await prefs.setString('cached_classes', jsonData);
      print('Lớp học đã được tải trước và lưu cache.');
    } catch (e) {
      print('Lỗi khi tải trước lớp học: $e');
    }
  }

  Future<Map<String, List<dynamic>>> getAllPersonalClass() async {
    List<ClassModel> classes = [];
    List<ProfileModel> classProfiles = [];

    try {
      await _initialize();
      final profiles = await getProfilesFromSharedPreferences();

      if (profiles.isEmpty) {
        print('Không có profile nào được lưu trong SharedPreferences');
        return {'profiles': [], 'classes': []};
      }

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      for (var profile in profiles) {
        if (profile.groupType != 1) {
          continue;
        }

        classProfiles.add(profile);

        final requestUrl = '$_baseUrl/classes/${profile.groupId}';
        final headers = {
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
          'x-profile-id': profile.id,
        };

        final response = await _dio.get(
          requestUrl,
          options: Options(headers: headers),
        );

        if (response.statusCode == 200) {
          classes.add(ClassModel.fromMap(response.data['data']));
        } else if (response.statusCode == 404) {
          print('Không tìm thấy lớp với ID profile: ${profile.id}');
          return {'profiles': classProfiles, 'classes': []};
        } else {
          print('Lỗi khi lấy lớp: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
          throw Exception('Failed to fetch class by ID: ${response.data}');
        }
      }
      return {'profiles': classProfiles, 'classes': classes};
    } catch (e) {
      print('Error fetching class by ID: $e');
      return {'profiles': [], 'classes': []};
    }
  }

  // Insert personal class
  Future<void> insertPersonalClass(String name, String? avatarUrl) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/class-icon.png';

      final response = await _dio.post(
        '$_baseUrl/classes',
        data: jsonEncode(
          {
            'name': name,
            'avatarUrl': finalAvatarUrl,
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to insert personal class: ${response.data}');
      }
    } catch (e) {
      print('Error inserting personal class: $e');
      throw e;
    }
  }

  // Insert personal class
  Future<void> insertSchoolClass(String name, String? avatarUrl) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final profile = await ProfileService().getProfileFromSharedPreferences();

      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/class-icon.png';

      final response = await _dio.post(
        '$_baseUrl/classes/${profile?.groupId}',
        data: jsonEncode(
          {
            'name': name,
            'avatarUrl': finalAvatarUrl,
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to insert personal class: ${response.data}');
      }
    } catch (e) {
      print('Error inserting personal class: $e');
      throw e;
    }
  }

  Future<void> updateClass(String newName) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final profile = await ProfileService().getProfileFromSharedPreferences();

      print(profile);

      final requestUrl = '$_baseUrl/classes/${profile?.groupId}';
      print('Request URL: $requestUrl');

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
        'x-profile-id': profile?.id,
      };

      print('Request Headers: $headers');

      final response = await _dio.patch(
        requestUrl,
        data: jsonEncode(
          {
            'name': newName,
          },
        ),
        options: Options(headers: headers),
      );

      print(response.data);

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to update class: ${response.data}');
      }
    } catch (e) {
      print('Error updating class: $e');
      throw e;
    }
  }
}
