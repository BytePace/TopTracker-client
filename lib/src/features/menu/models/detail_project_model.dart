class DetailProjectModel {
  final int id;
  final String name;
  final List<UserModel> users;
  final List<UserModel> invitations;
  final List<UserEngagementsModel> engagements;

  const DetailProjectModel({
    required this.users,
    required this.invitations,
    required this.id,
    required this.name,
    required this.engagements,
  });

  factory DetailProjectModel.fromJson(Map<String, dynamic> json) {
    final List<UserModel> users = [];
    json["users"].forEach((json) => {users.add(UserModel.fromJson(json))});

    final List<UserEngagementsModel> engagements = [];
    json["engagements"]
        .forEach((json) => {engagements.add(UserEngagementsModel.fromJson(json))});

    final List<UserModel> invitations = [];
    json["invitations"]
        .forEach((json) => {invitations.add(UserModel.fromJson(json))});

    return DetailProjectModel(
      id: json['project']['id'].toInt(),
      name: json['project']['name'],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }
}

class UserModel {
  final int id;
  final String name;

  const UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toInt(),
      name: json['name'],
    );
  }
}

class UserEngagementsModel {
  final int iserId;
  final int profileId;
  final int workedTotal;

  UserEngagementsModel({
    required this.iserId,
    required this.profileId,
    required this.workedTotal,
  });

  factory UserEngagementsModel.fromJson(Map<String, dynamic> json) {
    return UserEngagementsModel(
      iserId: json["user_id"].toInt(),
      profileId: json['profile_id'].toInt(),
      workedTotal: json['stats']['worked_total'].toInt(),
    );
  }
}
