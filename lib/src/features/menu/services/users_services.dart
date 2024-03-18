import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

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
      Uri.parse('${Config.baseUrl}/projects/$id/invitations'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      //final Map<String, dynamic> responseData = json.decode(response.body);

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
      Uri.parse('${Config.baseUrl}/projects/$projectId/workers/$profileId'),
    );
    if (response.statusCode == 200) {
      //final Map<String, dynamic> responseData = json.decode(response.body);

      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
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

  Future<void> getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final List<int> listProjectIDs = await getProjectsID();
    final Map<int, AllUsers> allUsers = {};
    for (int i = 0; i < listProjectIDs.length; i++) {
      final response2 = await http.get(Uri.parse(
          '${Config.baseUrl}/projects/${listProjectIDs[i]}/engagements?access_token=$access_token'));

      jsonDecode(utf8.decode(response2.bodyBytes))['workers']
          .forEach((element) {
        allUsers[element["id"]] = AllUsers.fromJson(element);
      });
    }
    Map<String, dynamic> jsonMap = {};
    allUsers.forEach((key, value) {
      jsonMap[key.toString()] = value.toJson();
    });
    prefs.setString("allUser", json.encode(jsonMap));
  }

  Future<List<ProfileID>> getAllProfileID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse(
        '${Config.baseUrl}/reports/filters?access_token=$access_token'));
    final List<ProfileID> idList = [];
    jsonDecode(utf8.decode(response.bodyBytes))["filters"]['workers']
        .forEach((element) {
      idList.add(ProfileID(profileID: element['id'], name: element["label"]));
    });
    return idList;
  }
}
