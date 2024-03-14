import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServices extends ChangeNotifier {
  Future<void> addUser(String email, String rate, String role, int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {
      "invites": [{'email': email, 'rate': rate, 'role': role}],
      "access_token": access_token
    };

    final response = await http.post(
      Uri.parse(
          'https://tracker-api.toptal.com/projects/$id/invitations'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);


      notifyListeners();
    } else {
      print(response.body);
      notifyListeners();
    }
  }

  Future<void> delUser(int projectId, int profileId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {'access_token': access_token};

    final response = await http.delete(
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
      Uri.parse(
          'https://tracker-api.toptal.com/projects/$projectId/workers/$profileId'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      notifyListeners();
    }
  }
}
