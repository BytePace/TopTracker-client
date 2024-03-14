class DetailProjectModel {
  final int id;
  final String name;
  final String currentUserRole;
  final List<UserModel> users;
  final List<UserModel> invitations;
  final List<UserEngagementsModel> engagements;

  const DetailProjectModel({
    required this.users,
    required this.invitations,
    required this.id,
    required this.name,
    required this.engagements,
    required this.currentUserRole, 
  });

  factory DetailProjectModel.fromJson(Map<String, dynamic> json, Map<String, dynamic> userJson) {
    final List<UserModel> users = [];
    userJson["workers"].forEach((userJson) => {users.add(UserModel.fromJson(userJson))});

    final List<UserEngagementsModel> engagements = [];
    userJson["statistics"]
        .forEach((userJson) => {engagements.add(UserEngagementsModel.fromJson(userJson))});

    final List<UserModel> invitations = [];
    userJson["invitations"]
        .forEach((userJson) => {invitations.add(UserModel.fromJson(userJson))});

    return DetailProjectModel(
      id: json['project']['id'].toInt(),
      name: json['project']['name'],
      currentUserRole: json['project']['current_user']['role'],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String? icon;

  const UserModel({
    required this.id,
    required this.name,
    required this.icon, 
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toInt(),
      name: json['name'],
      icon: json['avatar_url']
    );
  }
}

class UserEngagementsModel {
  final int profileId;
  final int workedTotal;

  UserEngagementsModel({
    required this.profileId,
    required this.workedTotal,
  });

  factory UserEngagementsModel.fromJson(Map<String, dynamic> json) {
    return UserEngagementsModel(
      profileId: json['profile_id'].toInt(),
      workedTotal: json['worked_total'].toInt(),
    );
  }
}
