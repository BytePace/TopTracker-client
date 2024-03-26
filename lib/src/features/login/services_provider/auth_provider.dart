
import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/login/models/login_model.dart';


abstract class AuthProvider extends ChangeNotifier {
  LoginModel user =
      const LoginModel(id: 0, email: "", access_token: "", username: '');

  void setUser(LoginModel user);

  Future<String> getToken();

  bool get isAuthorized;

  Future<void> logout();

  Future<void> login(String email, String password);
}
