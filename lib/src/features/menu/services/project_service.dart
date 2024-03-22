import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/utils/methods.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

class ProjectService extends ChangeNotifier {
  Future<List<ProjectModel>> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse(
        '${Config.baseUrl}/web/projects?access_token=$access_token&archived=true'));

    if (response.statusCode == 200) {
      final List<ProjectModel> projects = [];
      jsonDecode(utf8.decode(response.bodyBytes))["projects"]
          .forEach((json) => {projects.add(ProjectModel.fromJson(json))});
      return projects;
    } else {
      return [];
    }
  }

  Future<DetailProjectModel?> getDetailProject(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");
    final response = await http.get(Uri.parse(
        '${Config.baseUrl}/web/projects/$id?access_token=$access_token&archived=true'));
    if (response.statusCode == 200) {
      return DetailProjectModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<void> restoreProject(BuildContext context, int projectID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {"access_token": access_token};

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/projects/$projectID/dearchive'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showCnackBar(context, "Проект разархивирован");
      notifyListeners();
    } else {
      print(response.body);
      print(projectID);
      showCnackBar(context, "Произошла ошибка");
    }
  }

  Future<void> deleteProject(BuildContext context, int projectID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {"access_token": access_token};

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/projects/$projectID'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 204) {
      showCnackBar(context, "Проект удален");
      notifyListeners();
    } else {
      print(response.body);
      print(projectID);
      showCnackBar(context, "Произошла ошибка");
    }
  }

  List<UserModel> getListUsersOnProject(
      DetailProjectModel detailProjectModel, List<UserModel> allUsers) {
    final List<UserModel> usersOnProject = [];
    for (var userEngagement in detailProjectModel.engagements) {
      for (var user in allUsers) {
        if (userEngagement.profileId == user.profileID) {
          usersOnProject.add(user);
        }
      }
    }
    return usersOnProject;
  }

  List<ProfileID> getListUsersProfileIDOnProject(
      DetailProjectModel detailProjectModel, List<ProfileID> allUsers) {
    final List<ProfileID> usersOnProject = [];
    for (var userEngagement in detailProjectModel.engagements) {
      for (var user in allUsers) {
        if (userEngagement.profileId == user.profileID) {
          usersOnProject.add(user);
        }
      }
    }
    return usersOnProject;
  }
}
