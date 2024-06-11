import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/invite_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_engagements_dto.dart';

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
  @override
  String toString() {
    return 'DetailProjectModel{id: $id, name: $name, currentUserRole: $currentUserRole, users: $users, invitations: $invitations, engagements: $engagements}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetailProjectModel &&
        other.id == id &&
        other.name == name &&
        other.currentUserRole == currentUserRole &&
        _listEquals(other.users, users) &&
        _listEquals(other.invitations, invitations) &&
        _listEquals(other.engagements, engagements);
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        currentUserRole.hashCode ^
        _listHashCode(users) ^
        _listHashCode(invitations) ^
        _listHashCode(engagements);
  }

  int _listHashCode<T>(List<T> list) {
    int result = 0;
    for (var element in list) {
      result = result * 31 + element.hashCode;
    }
    return result;
  }
}

class UserEngagementsModel {
  final int userID;
  final int profileId;
  final int workedTotal;

  UserEngagementsModel({
    required this.userID,
    required this.profileId,
    required this.workedTotal,
  });

  factory UserEngagementsModel.fromDto(UserEngagementsDto dto) {
    return UserEngagementsModel(
      profileId: dto.profileId,
      workedTotal: dto.workedTotal,
      userID: dto.userID,
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
  final int userID;
  final String name;
  final String email;

  UserModel({required this.userID, required this.name, required this.email});

  factory UserModel.fromDto(UserDto dto) {
    return UserModel(
      email: dto.email,
      userID: dto.userID,
      name: dto.name,
    );
  }

  Map<String, dynamic> toMap(int projectID) {
    return {
      'profileID': userID,
      'name': name,
      'email': email,
      "detail_project_id": projectID
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
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
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InvitedModel &&
        other.name == name &&
        other.inviteID == inviteID;
  }

  @override
  int get hashCode => name.hashCode ^ inviteID.hashCode;
}
