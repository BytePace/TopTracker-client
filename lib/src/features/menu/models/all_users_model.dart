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
}


