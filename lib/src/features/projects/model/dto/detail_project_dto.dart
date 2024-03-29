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

  UserInfoDto({required this.profileID, required this.name, required this.email});

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
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
}
