import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/services_provider/users_provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/utils/methods.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

class UserServices extends UserProvider {
  @override
  Future<void> revokeInvite(int invitationID, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {'access_token': access_token};

    final response = await http.delete(
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
      Uri.parse('${Config.baseUrl}/invitations/$invitationID'),
    );
    if (response.statusCode == 200) {
      showCnackBar(context, "Приглашение отменено");
      notifyListeners();
    } else {
      showCnackBar(context, "Произошла ошибка");
    }
  }

  @override
  Future<void> addUser(String email, String rate, String role, int id,
      BuildContext context) async {
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
      showCnackBar(context, "Приглашение отправлено");
      notifyListeners();
    } else {
      print(response.body);
      showCnackBar(context, "Произошла ошибка");
    }
  }

  @override
  Future<void> delUser(
      int projectId, int profileId, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {'access_token': access_token};

    final response = await http.delete(
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
      Uri.parse('${Config.baseUrl}/projects/$projectId/workers/$profileId'),
    );
    if (response.statusCode == 200) {
      showCnackBar(context, "Пользователь удален");
      notifyListeners();
    } else {
      showCnackBar(context, "Произошла ошибка");
    }
  }

  @override
  Future<List<int>> getProjectsID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final responseIDs = await http.get(Uri.parse(
        '${Config.baseUrl}/web/projects?access_token=$access_token&archived=true'));
    List<int> projectID = [];

    if (responseIDs.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(utf8.decode(responseIDs.bodyBytes));
      map['projects'].forEach((project) => {
            if (project['archived_at'] == null) {projectID.add(project['id'])}
          }); //достаю все id всех проектов
    }
    return projectID;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final List<int> listProjectIDs = await getProjectsID();
    final Map<int, UserModel> allUsers = {};
    for (int i = 0; i < listProjectIDs.length; i++) {
      final response2 = await http.get(Uri.parse(
          '${Config.baseUrl}/projects/${listProjectIDs[i]}/engagements?access_token=$access_token&archived=true'));

      jsonDecode(utf8.decode(response2.bodyBytes))['workers']
          .forEach((element) {
        allUsers[element["id"]] = UserModel.fromJson(element);
      });
    }
    Map<String, dynamic> jsonMap = {};
    allUsers.forEach((key, value) {
      jsonMap[key.toString()] = value.toJson();
    });
    prefs.setString("allUser", json.encode(jsonMap));

    return allUsers.values.toList();
  }

  @override
  Future<List<ProfileID>> getAllProfileID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse(
        '${Config.baseUrl}/reports/filters?access_token=$access_token&archived=true'));
    final List<ProfileID> idList = [];
    jsonDecode(utf8.decode(response.bodyBytes))["filters"]['workers']
        .forEach((element) {
      idList.add(ProfileID(profileID: element['id'], name: element["label"]));
    });
    return idList;
  }

  @override
  List<ProjectModel> getUserProject(
      List<ProjectModel> projects, List<ProfileID> allUsersList, int index) {
    List<ProjectModel> projectModelList = [];

    for (ProjectModel project in projects) {
      for (var userProfileID in project.profilesIDs) {
        if (userProfileID == allUsersList[index].profileID) {
          projectModelList.add(project);
        }
      }
    }
    return projectModelList;
  }

  @override
  Future<List<UserModel>> checkAllUsers(List<ProfileID> allProfileID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String allUsersString = prefs.getString("allUser") ?? "{}";

    List<UserModel> list = [];
    json.decode((allUsersString)).forEach((key, value) {
      list.add(UserModel.fromJson(value));
    });

    print("${list.length}   ${allProfileID.length}");

    if (list.length != allProfileID.length) {
      return await getAllUsers();
    }
    return list;
  }
}
