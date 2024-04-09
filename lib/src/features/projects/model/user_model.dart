import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';

class UserInfoModel {
  final int profileID;
  final String name;
  final String email;
  final int workedTotal;

  UserInfoModel(
      {required this.profileID,
      required this.name,
      required this.email,
      required this.workedTotal});

  factory UserInfoModel.fromDto(UserInfoDto dto) {
    return UserInfoModel(
        profileID: dto.profileID,
        name: dto.name,
        email: dto.email,
        workedTotal: dto.workedTotal);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserInfoModel &&
        other.profileID == profileID &&
        other.name == name &&
        other.email == email &&
        other.workedTotal == workedTotal;
  }

  @override
  int get hashCode {
    return profileID.hashCode ^
        name.hashCode ^
        email.hashCode ^
        workedTotal.hashCode;
  }

  @override
  String toString() {
    return 'UserInfoModel{profileID: $profileID, name: $name, email: $email, workedTotal: $workedTotal}';
  }
}
