import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import '../../../core/config/cookie/token_manager.dart';
import '../models/user_model.dart';

class UserService extends ProfileService {
  static const String _baseUrl = 'https://cpserver.amrakk.rest/api/v1';
  final Dio _dio = Dio();

  UserService() {
    TokenManager.initialize();
  }


  // Đăng nhập và lưu cookie
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/users/$userId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );


      if (response.statusCode == 200) {
        print('Get user successfully!');

        UserModel user = UserModel.fromMap(response.data['data']['user']);
        return user;
      } else {
        print('Get user failure: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print('Lỗi khi lấy user: ${e.response!.data}');
    }
    print('Lỗi khi lấy user');
    return null;
  }
}
