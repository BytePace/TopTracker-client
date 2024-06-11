import 'package:tt_bytepace/src/database/database.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/invite_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_engagements_dto.dart';

class DetailProjectDto {
  final int id;
  final String name;
  final String currentUserRole;
  final List<UserDto> users;
  final List<InvitedDto> invitations;
  final List<UserEngagementsDto> engagements;

  const DetailProjectDto({
    required this.users,
    required this.invitations,
    required this.id,
    required this.name,
    required this.engagements,
    required this.currentUserRole,
  });

  factory DetailProjectDto.fromJson(Map<String, dynamic> json) {
    final List<UserDto> users = [];
    json["users"].forEach((json) => {users.add(UserDto.fromJson(json))});

    final List<UserEngagementsDto> engagements = [];
    json["engagements"].forEach(
        (json) => {engagements.add(UserEngagementsDto.fromJson(json))});
    final List<InvitedDto> invitations = [];
    json["invitations"]
        .forEach((json) => {invitations.add(InvitedDto.fromJson(json))});

    return DetailProjectDto(
      id: json[_JsonKey.project][_JsonKey.detaliProjectID].toInt(),
      name: json[_JsonKey.project][_JsonKey.name],
      currentUserRole: json[_JsonKey.project][_JsonKey.currentUser]
          [_JsonKey.role],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }

  factory DetailProjectDto.fromMap(
      Map<String, dynamic> map,
      List<UserDto> users,
      List<InvitedDto> invitations,
      List<UserEngagementsDto> engagements) {
    return DetailProjectDto(
      id: map[DbDetailProjectKeys.detailProjectID],
      name: map[DbDetailProjectKeys.name],
      currentUserRole: map[DbDetailProjectKeys.currentUserRole],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      DbDetailProjectKeys.detailProjectID: id,
      DbDetailProjectKeys.name: name,
      DbDetailProjectKeys.currentUserRole: currentUserRole
    };
  }

  @override
  String toString() {
    return "$users, $invitations, $id, $name, $engagements, $currentUserRole";
  }
}

class _JsonKey {
  static const detaliProjectID = 'id';
  static const project = "project";
  static const name = "name";
  static const currentUser = "current_user";
  static const role = "role";
}
