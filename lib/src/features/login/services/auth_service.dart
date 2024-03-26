import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/login/models/login_model.dart';
import 'package:tt_bytepace/src/features/login/services_provider/auth_provider.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

class AuthService extends AuthProvider {
  @override
  void setUser(LoginModel user) {
    this.user = user;
  }

  @override
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("access_token"));
    return prefs.getString("access_token") ?? "";
  }

  @override
  bool get isAuthorized {
    return user.access_token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    user = const LoginModel(id: 0, email: "", username: "", access_token: "");

    notifyListeners();
  }

  @override
  Future<void> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'remember_me': true
    };

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/sessions'),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setUser(LoginModel.fromJson(responseData));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", responseData['access_token']);

      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
