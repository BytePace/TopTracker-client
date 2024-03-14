import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

class ProjectService {

  Future<ProjectsModel> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse('https://tracker-api.toptal.com/web/projects?access_token=$access_token'));

    if (response.statusCode == 200) {
      return ProjectsModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      return ProjectsModel(projects: [], allUsers: []);
    }
  }

  Future<DetailProjectModel?> getDetailProject(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");
    print(access_token);

    final response = await http.get(Uri.parse('https://tracker-api.toptal.com/web/projects/$id?access_token=$access_token'));

    final userResponse = await http.get(Uri.parse('https://tracker-api.toptal.com/projects/$id/engagements?access_token=$access_token'));

    if (response.statusCode == 200 && userResponse.statusCode == 200) {
      print("object");
      return DetailProjectModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)), jsonDecode(utf8.decode(userResponse.bodyBytes)));
    } else {
      return null;
    }
  }
}
