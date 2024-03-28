import 'package:flutter/foundation.dart';
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
    json["users"].forEach((json) => {users.add(UserModel.fromJson(json))});

    return ProjectsModel(projects: projects, allUsers: users);
  }
}

class ProjectModel {
  final int id;
  final String name;
  final String adminName;
  final String createdAt;
  String? archivedAt;
  final List<int> profilesIDs;

  ProjectModel(
      {required this.id,
      required this.name,
      required this.adminName,
      required this.createdAt,
      required this.profilesIDs,
      required this.archivedAt});



  
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final List<int> profilesIDs = [];
    json["profiles_ids"].forEach((json) => {profilesIDs.add(json)});

    return ProjectModel(
        id: json['id'].toInt(),
        archivedAt: json['archived_at'],
        name: json['name'],
        adminName: json['admin_profile']['name'],
        createdAt: json['created_at'],
        profilesIDs: profilesIDs);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectModel &&
        other.id == id &&
        other.name == name &&
        other.adminName == adminName &&
        other.createdAt == createdAt &&
        other.archivedAt == archivedAt &&
        listEquals(other.profilesIDs, profilesIDs);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        adminName.hashCode ^
        createdAt.hashCode ^
        archivedAt.hashCode ^
        profilesIDs.hashCode;
  }

  @override
  String toString() {
    return "$name, $archivedAt";
  }
}
