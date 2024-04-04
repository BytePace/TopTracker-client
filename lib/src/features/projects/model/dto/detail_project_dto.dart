class DetailProjectDto {
  final int id;
  final String name;
  final String currentUserRole;
  final List<UserInfoDto> users;
  final List<InvitedDto> invitations;
  final List<UserEngagementsDto> engagements;

  const DetailProjectDto({
    required this.users,
    required this.invitations,
    required this.id,
    required this.name,
    required this.engagements,
    required this.currentUserRole,
  });

  factory DetailProjectDto.fromJson(Map<String, dynamic> json) {
    final List<UserInfoDto> users = [];
    json["users"].forEach((json) => {users.add(UserInfoDto.fromJson(json))});

    final List<UserEngagementsDto> engagements = [];
    json["engagements"].forEach(
        (json) => {engagements.add(UserEngagementsDto.fromJson(json))});
    final List<InvitedDto> invitations = [];
    json["invitations"]
        .forEach((json) => {invitations.add(InvitedDto.fromJson(json))});

    return DetailProjectDto(
      id: json['project']['id'].toInt(),
      name: json['project']['name'],
      currentUserRole: json['project']['current_user']['role'],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }

  factory DetailProjectDto.fromMap(
      Map<String, dynamic> map,
      List<UserInfoDto> users,
      List<InvitedDto> invitations,
      List<UserEngagementsDto> engagements) {
    return DetailProjectDto(
      id: map['datail_project_id'].toInt(),
      name: map['name'],
      currentUserRole: map['currentUserRole'],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }
}

class UserEngagementsDto {
  final int profileId;
  final int workedTotal;

  UserEngagementsDto({
    required this.profileId,
    required this.workedTotal,
  });

  factory UserEngagementsDto.fromJson(Map<String, dynamic> json) {
    return UserEngagementsDto(
      profileId: json['profile_id'].toInt(),
      workedTotal: json['stats']['worked_total'].toInt(),
    );
  }

  factory UserEngagementsDto.fromMap(Map<String, dynamic> map) {
    return UserEngagementsDto(
      profileId: map['user_engagaments_id'].toInt(),
      workedTotal: map['workedTotal'].toInt(),
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEngagementsDto &&
        other.profileId == profileId &&
        other.workedTotal == workedTotal;
  }

  @override
  int get hashCode {
    return profileId.hashCode ^ workedTotal.hashCode;
  }

  @override
  String toString() {
    return 'UserEngagementsModel{profileId: $profileId, workedTotal: $workedTotal}';
  }
}

class UserInfoDto {
  final int profileID;
  final String name;
  final String email;

  UserInfoDto(
      {required this.profileID, required this.name, required this.email});

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
      email: json['email'],
      profileID: json['id'].toInt(),
      name: json['name'],
    );
  }
    factory UserInfoDto.fromMap(Map<String, dynamic> map) {
    return UserInfoDto(
      email: map['email'],
      profileID: map['profile_id'].toInt(),
      name: map['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "id": profileID,
      "name": name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfoDto &&
        other.profileID == profileID &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return profileID.hashCode ^ name.hashCode ^ email.hashCode;
  }

  @override
  String toString() {
    return 'UserModel{profileID: $profileID, name: $name}';
  }
}

class InvitedDto {
  final String? name;
  final int inviteID;

  const InvitedDto({
    required this.inviteID,
    required this.name,
  });

  factory InvitedDto.fromJson(Map<String, dynamic> json) {
    return InvitedDto(
      name: json['name'],
      inviteID: json['id'].toInt(),
    );
  }
  factory InvitedDto.fromMap(Map<String, dynamic> map) {
    return InvitedDto(
      name: map['name'],
      inviteID: map['invite_id'],
    );
  }
}
