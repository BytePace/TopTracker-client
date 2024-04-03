import 'package:flutter/foundation.dart';

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
        id: json['id'].toInt(),
        archivedAt: json['archived_at'],
        name: json['name'],
        adminName: json['admin_profile']['name'],
        createdAt: json['created_at'],
        currentUser: json['current_user']['role'],
        profilesIDs: profilesIDs);
  }

  factory ProjectDto.fromMap(Map<String, dynamic> map) {
    final List<int> profilesIDs = [];
    map["profiles_ids"].forEach((json) => {profilesIDs.add(json)});

    return ProjectDto(
        id: map['id'].toInt(),
        archivedAt: map['archived_at'],
        name: map['name'],
        adminName: map['admin_name'],
        createdAt: map['created_at'],
        currentUser: map['current_user_role'],
        profilesIDs: profilesIDs);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'adminName': adminName,
      'createdAt': createdAt,
      'archivedAt': archivedAt,
      'profilesIDs': profilesIDs,
      'currentUser': currentUser,
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
    return "$name, $archivedAt";
  }
}
