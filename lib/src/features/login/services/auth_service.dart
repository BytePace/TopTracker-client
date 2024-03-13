import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/login/models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel _user =
      const UserModel(id: 0, email: "", username: "", access_token: "");


  void setUser(UserModel user) {
    _user = user;
  }


  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  
  bool get isAuthorized {
    return _user.access_token.isNotEmpty;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _user = const UserModel(id: 0, email: "", username: "", access_token: "");

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'remember_me': true
    };

    final response = await http.post(
      Uri.parse('https://tracker-api.toptal.com/sessions'),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setUser(UserModel.fromJson(responseData));
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", responseData['access_token']);

      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      notifyListeners();
    }
  }
}
