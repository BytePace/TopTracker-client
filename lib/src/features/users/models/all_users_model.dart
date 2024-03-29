import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

class ProfileIdModel {
  final int profileID;
  final String name;

  ProfileIdModel({required this.profileID, required this.name});

  factory ProfileIdModel.fromDto(ProfileIdDto dto) {
    return ProfileIdModel(
      name: dto.name,
      profileID: dto.profileID,
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileIdModel &&
        other.profileID == profileID &&
        other.name == name;
  }

  @override
  int get hashCode => profileID.hashCode ^ name.hashCode;
}
