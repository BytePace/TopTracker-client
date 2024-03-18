import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';

class UserServices extends ChangeNotifier {
  Future<void> addUser(String email, String rate, String role, int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {
      "invites": [
        {'email': email, 'rate': rate, 'role': role}
      ],
      "access_token": access_token
    };

    final response = await http.post(
      Uri.parse('https://tracker-api.toptal.com/projects/$id/invitations'),
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

  Future<List<int>> getProjectsID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final responseIDs = await http.get(Uri.parse(
        'https://tracker-api.toptal.com/web/projects?access_token=$access_token'));
    List<int> projectID = [];

    if (responseIDs.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(utf8.decode(responseIDs.bodyBytes));
      map['projects'].forEach(
          (id) => {projectID.add(id['id'])}); //достаю все id всех проектовÏ
    }
    return projectID;
  }

  Future<AllUsersList> getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse(
        'https://tracker-api.toptal.com/reports/filters?access_token=$access_token'));

  
      return AllUsersList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  

    //List<int> projectID = await getProjectsID();
    //print(projectID);
    //List<Map<int, UserModel>> map = [];

    //for (var e in projectID) {
    //  final response = await http.get(Uri.parse(
    //      'https://tracker-api.toptal.com/projects/$e/engagements?access_token=$access_token'));
    //  if (response.statusCode == 200) {
    //    map.add(
    //        Users.fromJson(jsonDecode(utf8.decode(response.bodyBytes))).users);
    //  }
    //}
  }

  //final response = await http.get(Uri.parse('https://tracker-api.toptal.com/web/projects?access_token=$access_token'));
//
  //if (response.statusCode == 200) {
  //  notifyListeners();
  //  return  {1:AllUsers(email: "", profileID: 2, name: '', userID: 2)}; //AllUsers.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  //} else {
  //  return null;
  //}
  //}
}
