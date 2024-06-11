import 'package:tt_bytepace/src/database/database.dart';

class InvitedDto {
  final String? name;
  final int inviteID;

  const InvitedDto({
    required this.inviteID,
    required this.name,
  });

  Map<String, dynamic> toMap(int projectID) {
    return {
      DbInvitesKeys.inviteID: inviteID,
      DbInvitesKeys.name: name,
      DbInvitesKeys.detailProjectID: projectID
    };
  }

  factory InvitedDto.fromJson(Map<String, dynamic> json) {
    return InvitedDto(
      name: json[_JsonKey.invitename],
      inviteID: json[_JsonKey.inviteID].toInt(),
    );
  }
  factory InvitedDto.fromMap(Map<String, dynamic> map) {
    return InvitedDto(
      name: map[DbInvitesKeys.name],
      inviteID: map[DbInvitesKeys.inviteID],
    );
  }
}

class _JsonKey {
  static const inviteID = "id";
  static const invitename = "name";
}
