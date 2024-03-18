import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';

class ProjectsModel {
  final List<ProjectModel> projects;
  final List<UserModel> usersOnProject;

  ProjectsModel({required this.projects, required this.usersOnProject,});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    final List<ProjectModel> projects = [];
    json["projects"]
        .forEach((json) => {projects.add(ProjectModel.fromJson(json))});

    final List<UserModel> users = [];
    json["users"]
        .forEach((json) => {users.add(UserModel.fromJson(json))});

    return ProjectsModel(projects: projects, usersOnProject: users);
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

