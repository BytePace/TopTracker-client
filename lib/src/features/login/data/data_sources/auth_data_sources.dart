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
    await prefs.remove('access_token');
  }

  @override
  Future<LoginDto> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'remember_me': true
    };
    try {
      final response =
          await _dio.post('/sessions', data: loginData);

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", response.data['access_token']);
        return LoginDto.fromJson(response.data);
      } else {
        print(response.statusCode);
        print(response.data);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to login $e');
    }
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }
}
