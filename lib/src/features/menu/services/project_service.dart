import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

class ProjectService {

  Future<ProjectsModel?> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse('https://tracker-api.toptal.com/web/projects?access_token=$access_token'));

    if (response.statusCode == 200) {
      print(response.body);
      return ProjectsModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      return null;
    }
  }

  Future<DetailProjectModel?> getDetailProject(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await http.get(Uri.parse('https://tracker-api.toptal.com/web/projects/$id?access_token=$access_token'));

    if (response.statusCode == 200) {
      print(response.body);
      return DetailProjectModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      return null;
    }
  }
}
