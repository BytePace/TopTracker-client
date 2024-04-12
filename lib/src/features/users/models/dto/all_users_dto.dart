import 'package:tt_bytepace/src/database/database.dart';

class ProfileIdDto {
  final int profileID;
  final String name;

  ProfileIdDto({required this.profileID, required this.name});

  factory ProfileIdDto.fromJson(Map<String, dynamic> json) {
    return ProfileIdDto(
      name: json[_JsonKey.userName],
      profileID: json[_JsonKey.profileID].toInt(),
    );
  }
  factory ProfileIdDto.fromMap(Map<String, dynamic> map) {
    return ProfileIdDto(
      name: map[DbUsersKeys.name],
      profileID: map[DbUsersKeys.profileID].toInt(),
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileIdDto &&
        other.profileID == profileID &&
        other.name == name;
  }

  @override
  int get hashCode => profileID.hashCode ^ name.hashCode;
}

class _JsonKey {
  static const userName = 'label';
  static const profileID = "id";
}
