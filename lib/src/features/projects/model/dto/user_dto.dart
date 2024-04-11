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
      profileID: json["data"][0]['id'].toInt(),
      name: json["data"][0]['label'],
      workedTotal: json['total_seconds'].toInt(),
    );
  }

  @override
  List<Object?> get props => [profileID, name, email, workedTotal];

  @override
  bool? get stringify => true;
}
