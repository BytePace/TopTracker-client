
import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';

class ProjectsModel {
  final List<ProjectModel> projects;
  final List<UserModel> allUsers;


  ProjectsModel({required this.projects, required this.allUsers});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    final List<ProjectModel> projects = [];
    json["projects"]
        .forEach((json) => {projects.add(ProjectModel.fromJson(json))});

    final List<UserModel> users = [];
    json["users"]
        .forEach((json) => {users.add(UserModel.fromJson(json))});
        users.map((e) => debugPrint(e.name));


    return ProjectsModel(projects: projects, allUsers: users);
  }
}

class ProjectModel {
  final int id;
  final String name;
  final String adminName;
  final String createdAt;
  final List<int> profilesIDs;
  

  const ProjectModel({
    required this.id,
    required this.name,
    required this.adminName,
    required this.createdAt,
    required this.profilesIDs
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final List<int> profilesIDs = [];
    json["profiles_ids"]
        .forEach((json) => {profilesIDs.add(json)});

    return ProjectModel(
      id: json['id'].toInt(),
      name: json['name'],
      adminName: json['admin_profile']['name'],
      createdAt: json['created_at'],
      profilesIDs: profilesIDs
    );
  }
}

