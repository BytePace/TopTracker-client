class ProfileIdDto {
  final int profileID;
  final String name;

  ProfileIdDto({required this.profileID, required this.name});

  factory ProfileIdDto.fromJson(Map<String, dynamic> json) {
    return ProfileIdDto(
      name: json['label'],
      profileID: json['id'].toInt(),
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
