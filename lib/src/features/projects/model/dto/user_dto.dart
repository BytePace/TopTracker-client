class UserInfoDto {
  final int profileID;
  final String name;
  final String email;
  final int workedTotal;

  UserInfoDto(
      {required this.profileID,
      required this.name,
      required this.email,
      required this.workedTotal});

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
        email: "",
        profileID: json["data"][0]['id'].toInt(),
        name: json["data"][0]['label'],
        workedTotal: json['total_seconds'].toInt());
  }
}
