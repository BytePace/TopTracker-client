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

class AllUsers {
  final int profileID;
  final String name;
  final String email;

  AllUsers({required this.profileID, required this.name, required this.email});

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    return AllUsers(
      email: json['email'],
      profileID: json['id'].toInt(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "id": profileID,
      "name": name,
    };
  }
}
