import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/database/database.dart';
import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';

abstract interface class IAuthDataSources {
  Future<void> logout();

  Future<LoginDto> login(String email, String password);

  Future<String?> getToken();
  Future<void> dropDB();
}

class NetworkAuthDataSources implements IAuthDataSources {
  final Dio _dio;
  final SharedPreferences _prefs;

  const NetworkAuthDataSources(
      {required Dio dio, required SharedPreferences prefs})
      : _dio = dio,
        _prefs = prefs;

  @override
  Future<void> logout() async {
    final loginData = {"access_token": _prefs.getString("access_token")};
    await _dio.delete('/sessions/me', data: loginData);
    await _prefs.remove('access_token');
    await _prefs.remove('current_user_id');
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
        await _prefs.setString("access_token", response.data['access_token']);
        await _prefs.setInt(
            "current_user_id", response.data['profiles'][0]['id'].toInt());
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
    return _prefs.getString("access_token");
  }

  @override
  Future<void> dropDB() async {
    final database = await DBProvider.db.database;
    await database.delete('UserEngagements');
    await database.delete('Invites');
    await database.delete('UserInfo');
    await database.delete('UsersProfileID');
    await database.delete('DetailProject');
    await database.delete('Projects');
  }
}
