import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

class ProjectService {
  Future<List<ProjectModel>> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(
        Uri.parse('${Config.baseUrl}/web/projects?access_token=$access_token&archived=false'));

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
        '${Config.baseUrl}/web/projects/$id?access_token=$access_token&archived=false'));
    if (response.statusCode == 200) {
      return DetailProjectModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print(response.statusCode);
      return null;
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
}
