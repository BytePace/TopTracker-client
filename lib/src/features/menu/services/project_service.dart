import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

class ProjectService {
  Future<ProjectsModel> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(
        Uri.parse('${Config.baseUrl}/web/projects?access_token=$access_token'));

    if (response.statusCode == 200) {
      return ProjectsModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      return ProjectsModel(projects: [], usersOnProject: []);
    }
  }

  Future<DetailProjectModel?> getDetailProject(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");
    print(access_token);

    try {
      final response = await http.get(Uri.parse(
          '${Config.baseUrl}/web/projects/$id?access_token=$access_token'));

      final userResponse = await http.get(Uri.parse(
          '${Config.baseUrl}/projects/$id/engagements?access_token=$access_token'));

      if (response.statusCode == 200 && userResponse.statusCode == 200) {
        return DetailProjectModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)),
            jsonDecode(utf8.decode(userResponse.bodyBytes)));
      } else {
        print(response.statusCode);
        print(userResponse.statusCode);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
    
  }
}
