
class DetailProjectModel {
  final int id;
  final String name;
  final String currentUserRole;
  final List<UserModel> users;
  final List<InvitedModel> invitations;
  final List<UserEngagementsModel> engagements;

  const DetailProjectModel({
    required this.users,
    required this.invitations,
    required this.id,
    required this.name,
    required this.engagements,
    required this.currentUserRole, 
  });

  factory DetailProjectModel.fromJson(Map<String, dynamic> json) {
    final List<UserModel> users = [];
    json["users"].forEach((json) => {users.add(UserModel.fromJson(json))});

    final List<UserEngagementsModel> engagements = [];
    json["engagements"]
        .forEach((json) => {engagements.add(UserEngagementsModel.fromJson(json))});
    final List<InvitedModel> invitations = [];
    json["invitations"]
        .forEach((json) => {invitations.add(InvitedModel.fromJson(json))});

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
      workedTotal: json['stats']['worked_total'].toInt(),
    );
  }
}

class UserModel {
  final int profileID;
  final String name;
  final String email;

  UserModel({required this.profileID, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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

class InvitedModel {

  final String? name;
  final int inviteID;

  const InvitedModel({
    required this.inviteID,
    required this.name,

  });

  factory InvitedModel.fromJson(Map<String, dynamic> json) {
    return InvitedModel(
      name: json['name'],
      inviteID: json['id'].toInt(),
    );
  }
}