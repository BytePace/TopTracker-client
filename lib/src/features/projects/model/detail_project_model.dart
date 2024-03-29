import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';

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

  factory DetailProjectModel.fromDto(DetailProjectDto dto) {
    final List<UserModel> users = [];
    for (var user in dto.users) {
      users.add(UserModel.fromDto(user));
    }

    final List<UserEngagementsModel> engagements = [];
    for (var engagement in dto.engagements) {
      engagements.add(UserEngagementsModel.fromDto(engagement));
    }
    final List<InvitedModel> invites = [];
    for (var invite in dto.invitations) {
      invites.add(InvitedModel.fromDto(invite));
    }

    return DetailProjectModel(
      id: dto.id,
      name: dto.name,
      currentUserRole: dto.currentUserRole,
      users: users,
      invitations: invites,
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

  factory UserEngagementsModel.fromDto(UserEngagementsDto dto) {
    return UserEngagementsModel(
      profileId: dto.profileId,
      workedTotal: dto.workedTotal,
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEngagementsModel &&
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

class UserModel {
  final int profileID;
  final String name;
  final String email;

  UserModel({required this.profileID, required this.name, required this.email});

  factory UserModel.fromDto(UserInfoDto dto) {
    return UserModel(
      email: dto.email,
      profileID: dto.profileID,
      name: dto.name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
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

class InvitedModel {
  final String? name;
  final int inviteID;

  const InvitedModel({
    required this.inviteID,
    required this.name,
  });

  factory InvitedModel.fromDto(InvitedDto dto) {
    return InvitedModel(
      name: dto.name,
      inviteID: dto.inviteID,
    );
  }
}
