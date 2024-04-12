import 'package:tt_bytepace/src/database/database.dart';

class UserDto {
  final int userID;
  final String name;
  final String email;

  UserDto({required this.userID, required this.name, required this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      email: json[_JsonUserKey.email],
      userID: json[_JsonUserKey.userID].toInt(),
      name: json[_JsonUserKey.username],
    );
  }

  Map<String, dynamic> toMap(int projectID) {
    return {
      DbUserInfoKeys.userID: userID,
      DbUserInfoKeys.name: name,
      DbUserInfoKeys.email: email,
      DbUserInfoKeys.detailProjectID: projectID
    };
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      email: map[DbUsersKeys.email],
      userID: map[DbUsersKeys.profileID],
      name: map[DbUsersKeys.name],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _JsonUserKey.email: email,
      _JsonUserKey.userID: userID,
      _JsonUserKey.username: name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDto &&
        other.userID == userID &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return userID.hashCode ^ name.hashCode ^ email.hashCode;
  }

  @override
  String toString() {
    return 'UserModel{profileID: $userID, name: $name}';
  }
}

class _JsonUserKey {
  static const userID = "id";
  static const username = "name";
  static const email = "email";
}
