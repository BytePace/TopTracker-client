import 'package:equatable/equatable.dart';

class UserInfoDto extends Equatable {
  final int profileID;
  final String name;
  final String email;
  final int workedTotal;

  const UserInfoDto({
    required this.profileID,
    required this.name,
    required this.email,
    required this.workedTotal,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
      email: "",
      profileID: json[_JsonKey.data][0][_JsonKey.profileID].toInt(),
      name: json[_JsonKey.data][0][_JsonKey.userName],
      workedTotal: json[_JsonKey.workedTotal].toInt(),
    );
  }

  @override
  List<Object?> get props => [profileID, name, email, workedTotal];

  @override
  bool? get stringify => true;

  
}

class _JsonKey {
  static const data = "data";
  static const profileID = "id";
  static const userName = "label";
  static const workedTotal = "total_seconds";
}
