import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';

abstract interface class IAuthDataSources {
  Future<void> logout();

  Future<LoginDto> login(String email, String password);

  Future<String?> getToken();
}

class NetworkAuthDataSources implements IAuthDataSources {
  final Dio _dio;

  const NetworkAuthDataSources({required Dio dio}) : _dio = dio;

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final loginData = {"access_token": prefs.getString("access_token")};
    await _dio.delete('/sessions/me', data: loginData);
    await prefs.remove('access_token');
    await prefs.remove('current_user_id');
  }

  @override
  Future<LoginDto> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'remember_me': true
    };
    try {
      final response = await _dio.post('/sessions', data: loginData);

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", response.data['access_token']);
        await prefs.setInt("current_user_id", response.data['profiles'][0]['id'].toInt());
        return LoginDto.fromJson(response.data);
      } else {
        print(response.statusCode);
        print(response.data);
        throw Exception('Failed to load data');
      }
    } on Exception {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }
}
