class ProfileID {
  final int profileID;
  final String name;

  ProfileID({required this.profileID, required this.name});

  factory ProfileID.fromJson(Map<String, dynamic> json) {
    return ProfileID(
      name: json['label'],
      profileID: json['id'].toInt(),
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileID &&
        other.profileID == profileID &&
        other.name == name;
  }

  @override
  int get hashCode => profileID.hashCode ^ name.hashCode;
}
