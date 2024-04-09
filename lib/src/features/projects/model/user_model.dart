import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
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
}
