import 'dart:convert';
import 'package:classpal_flutter_app/features/auth/models/profile_model.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolService {
  final String _baseUrl =
      'https://cpserver.amrakk.rest/api/v1/academic-service';
  final Dio _dio = Dio();
  late PersistCookieJar _cookieJar;

  SchoolService() {
    _initialize();
  }

  // Khởi tạo PersistCookieJar để lưu trữ cookie
  Future<void> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookieStorage = FileStorage('${directory.path}/cookies');
    _cookieJar = PersistCookieJar(storage: cookieStorage);
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Restore cookies khi khởi tạo
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

  Future<List<SchoolModel>> getAllSchools() async {
    List<SchoolModel> schools = [];

    try {
      // Lấy danh sách Profile từ SharedPreferences
      List<ProfileModel> profiles = await getProfilesFromSharedPreferences();
      print(profiles);

      // Kiểm tra danh sách profile có trống không
      if (profiles.isEmpty) {
        print('Không có profile nào được lưu trong SharedPreferences');
        return [];
      }

      // Lấy cookies từ PersistCookieJar
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      // Tạo cookie header cho yêu cầu
      final cookieHeader =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      // Duyệt qua danh sách profile và thực hiện yêu cầu API cho từng profile
      for (var profile in profiles) {
        print(profile.id);
        final requestUrl = '$_baseUrl/schools/${profile.id}';
        print('Request URL: $requestUrl'); // Log URL yêu cầu

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
          // Nếu thành công, thêm trường vào danh sách
          schools.add(SchoolModel.fromMap(response.data['data']));
        } else if (response.statusCode == 404) {
          // Xử lý lỗi 404 khi không tìm thấy trường
          print('Không tìm thấy trường với ID profile: ${profile.id}');
          return []; // Hoặc bạn có thể chỉ log và tiếp tục với các profile khác
        } else {
          // In ra lỗi nếu không phải 404
          print('Lỗi khi lấy trường: Mã lỗi ${response.statusCode}, Thông báo: ${response.data}');
          throw Exception('Failed to fetch school by ID: ${response.data}');
        }
      }

      return schools; // Trả về danh sách các trường
    } catch (e) {
      print('Error fetching school by ID: $e');
      return []; // Trả về danh sách rỗng khi có lỗi
    }
  }


  // Thêm trường mới
  Future<void> insertSchool(String name, String address, String phoneNumber,
      String? avatarUrl) async {
    try {
      final cookies = await _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      if (cookies.isEmpty) {
        throw Exception('No cookies available for authentication');
      }

      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      // Sử dụng avatarUrl mặc định nếu không có giá trị
      final finalAvatarUrl =
          avatarUrl ?? 'https://i.ibb.co/V9Znq7h/school-icon.png';

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
        throw Exception('Failed to insert school: ${response.data}');
      }
    } catch (e) {
      print('Error inserting school: $e');
      throw e;
    }
  }
}
