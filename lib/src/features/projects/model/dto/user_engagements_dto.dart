import 'package:tt_bytepace/src/database/database.dart';

class UserEngagementsDto {
  final int profileId;
  final int userID;
  final int workedTotal;

  UserEngagementsDto(
      {required this.profileId,
      required this.workedTotal,
      required this.userID});

  Map<String, dynamic> toMap(int projectID) {
    return {
      DbUserEngagementsKeys.userEngagementsID: profileId,
      DbUserEngagementsKeys.userID: userID,
      DbUserEngagementsKeys.workedTotal: workedTotal,
      DbUserEngagementsKeys.detailProjectID: projectID
    };
  }

  factory UserEngagementsDto.fromJson(Map<String, dynamic> json) {
    return UserEngagementsDto(
      profileId: json[_JsonKey.profileID].toInt(),
      userID: json[_JsonKey.userID].toInt(),
      workedTotal: json[_JsonKey.stats][_JsonKey.workedTotal].toInt(),
    );
  }

  factory UserEngagementsDto.fromMap(Map<String, dynamic> map) {
    return UserEngagementsDto(
      userID: map[DbUserEngagementsKeys.userID],
      profileId: map[DbUserEngagementsKeys.userEngagementsID],
      workedTotal: map[DbUserEngagementsKeys.workedTotal],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEngagementsDto &&
        other.profileId == profileId &&
        other.workedTotal == workedTotal;
  }

  @override
  int get hashCode {
    return profileId.hashCode ^ workedTotal.hashCode;
  }

  @override
  String toString() {
    return 'UserEngagementsModel{profileId: $profileId, workedTotal: $workedTotal}';
  }
}

class _JsonKey {
  static const userID = "user_id";
  static const profileID = "profile_id";
  static const stats = "stats";
  static const workedTotal = "worked_total";
}
