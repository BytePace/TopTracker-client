import 'package:flutter/foundation.dart';
import 'package:tt_bytepace/src/database/database.dart';

class ProjectDto {
  final int id;
  final String name;
  final String adminName;
  final String createdAt;
  String? archivedAt;
  final List<int> profilesIDs;
  final String currentUser;

  ProjectDto(
      {required this.id,
      required this.name,
      required this.adminName,
      required this.createdAt,
      required this.profilesIDs,
      required this.archivedAt,
      required this.currentUser});

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    final List<int> profilesIDs = [];
    json["profiles_ids"].forEach((json) => {profilesIDs.add(json)});

    return ProjectDto(
        id: json[_JsonKey.projectID].toInt(),
        archivedAt: json[_JsonKey.archivedAt],
        name: json[_JsonKey.name],
        adminName: json[_JsonKey.adminProfile][_JsonKey.adminName],
        createdAt: json[_JsonKey.createdAt],
        currentUser: json[_JsonKey.currentUser][_JsonKey.currentUserRole],
        profilesIDs: profilesIDs);
  }

  factory ProjectDto.fromMap(Map<String, dynamic> map, List<int> profilesIDs) {
    return ProjectDto(
        id: map[DbProjectsKeys.id],
        archivedAt: map[DbProjectsKeys.archivedAt],
        name: map[DbProjectsKeys.name],
        adminName: map[DbProjectsKeys.adminName],
        createdAt: map[DbProjectsKeys.createdAt],
        currentUser: map[DbProjectsKeys.currentUser],
        profilesIDs: profilesIDs);
  }
  Map<String, dynamic> toMap() {
    return {
      DbProjectsKeys.id: id,
      DbProjectsKeys.name: name,
      DbProjectsKeys.adminName: adminName,
      DbProjectsKeys.createdAt: createdAt,
      DbProjectsKeys.archivedAt: archivedAt,
      'profilesIDs': profilesIDs,
      DbProjectsKeys.currentUser: currentUser,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectDto &&
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
    return "$name + $archivedAt";
  }
}

class _JsonKey {
  static const projectID = "id";
  static const archivedAt = "archived_at";
  static const name = "name";
  static const adminProfile = "admin_profile";
  static const adminName = "name";
  static const createdAt = "created_at";
  static const currentUser = "current_user";
  static const currentUserRole = "role";
}
