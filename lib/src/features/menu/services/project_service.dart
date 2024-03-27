import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/services_provider/project_provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/utils/methods.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

class ProjectService extends ProjectProvider {
  @override
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

  @override
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

  @override
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
      Navigator.pop(context);
      showCnackBar(context, "Проект разархивирован");

      notifyListeners();
    } else {
      print(response.body);
      print(projectID);
      showCnackBar(context, "Произошла ошибка");
    }
  }

  @override
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
      Navigator.pop(context);
      showCnackBar(context, "Проект удален");

      notifyListeners();
    } else {
      print(response.body);
      print(projectID);
      showCnackBar(context, "Произошла ошибка");
    }
  }

  @override
  List<UserModel> getListUsersOnProject(
      List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
    final List<UserModel> usersOnProject = [];
    for (var userEngagement in engagements) {
      for (var user in allUsers) {
        if (userEngagement.profileId == user.profileID) {
          usersOnProject.add(user);
        }
      }
    }
    return usersOnProject;
  }

  @override
  List<ProfileID> getListUsersProfileIDOnProject(
      List<UserEngagementsModel> engagements,
      List<ProfileID> allUsersProfileID) {
    final List<ProfileID> usersOnProject = [];
    for (var userEngagement in engagements) {
      for (var user in allUsersProfileID) {
        if (userEngagement.profileId == user.profileID) {
          usersOnProject.add(user);
        }
      }
    }
    return usersOnProject;
  }

  @override
  List<UserModel> getAllUsersWhithoutOnProject(
      List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
    List<UserModel> list = List.from(allUsers);
    for (var usr in allUsers) {
      for (var user in engagements) {
        if (usr.profileID == user.profileId) {
          list.remove(usr);
          break;
        }
      }
    }
    return list;
  }
}
