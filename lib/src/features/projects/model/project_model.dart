import 'package:flutter/foundation.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';

class ProjectModel {
  final int id;
  final String name;
  final String adminName;
  final String createdAt;
  String? archivedAt;
  final List<int> profilesIDs;
  final String currentUser;

  ProjectModel(
      {required this.id,
      required this.name,
      required this.adminName,
      required this.createdAt,
      required this.profilesIDs,
      required this.archivedAt,
      required this.currentUser});

  factory ProjectModel.fromDto(ProjectDto dto) {
    return ProjectModel(
      id: dto.id,
      archivedAt: dto.archivedAt,
      name: dto.name,
      adminName: dto.adminName,
      createdAt: dto.createdAt,
      currentUser: dto.currentUser,
      profilesIDs: dto.profilesIDs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'adminName': adminName,
      'createdAt': createdAt,
      'archivedAt': archivedAt,
      'currentUser': currentUser,
    };
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
