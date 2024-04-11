class DetailProjectDto {
  final int id;
  final String name;
  final String currentUserRole;
  final List<UserDto> users;
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
    final List<UserDto> users = [];
    json["users"].forEach((json) => {users.add(UserDto.fromJson(json))});

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
      List<UserDto> users,
      List<InvitedDto> invitations,
      List<UserEngagementsDto> engagements) {
    return DetailProjectDto(
      id: map['detail_project_id'],
      name: map['name'],
      currentUserRole: map['currentUserRole'],
      users: users,
      invitations: invitations,
      engagements: engagements,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'detail_project_id': id,
      'name': name,
      'currentUserRole': currentUserRole
    };
  }

  @override
  String toString() {
    return "$users, $invitations, $id, $name, $engagements, $currentUserRole";
  }
}

class UserEngagementsDto {
  final int profileId;
  final int userID;
  final int workedTotal;

  UserEngagementsDto(
      {required this.profileId,
      required this.workedTotal,
      required this.userID});

  Map<String, dynamic> toMap(int projectID) {
    return {
      'user_engagaments_id': profileId,
      'userID': userID,
      'workedTotal': workedTotal,
      "detail_project_id": projectID
    };
  }

  factory UserEngagementsDto.fromJson(Map<String, dynamic> json) {
    return UserEngagementsDto(
      profileId: json['profile_id'].toInt(),
      userID: json['user_id'].toInt(),
      workedTotal: json['stats']['worked_total'].toInt(),
    );
  }

  factory UserEngagementsDto.fromMap(Map<String, dynamic> map) {
    return UserEngagementsDto(
      userID: map['userID'],
      profileId: map['user_engagaments_id'],
      workedTotal: map['workedTotal'],
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

class UserDto {
  final int userID;
  final String name;
  final String email;

  UserDto({required this.userID, required this.name, required this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      email: json['email'],
      userID: json['id'].toInt(),
      name: json['name'],
    );
  }


  Map<String, dynamic> toMap(int projectID) {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      "detail_project_id": projectID
    };
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      email: map['email'],
      userID: map['profile_id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "id": userID,
      "name": name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDto &&
        other.userID == userID &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return userID.hashCode ^ name.hashCode ^ email.hashCode;
  }

  @override
  String toString() {
    return 'UserModel{profileID: $userID, name: $name}';
  }
}

class InvitedDto {
  final String? name;
  final int inviteID;

  const InvitedDto({
    required this.inviteID,
    required this.name,
  });

  Map<String, dynamic> toMap(int projectID) {
    return {
      'invite_id': inviteID,
      'name': name,
      "detail_project_id": projectID
    };
  }

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
