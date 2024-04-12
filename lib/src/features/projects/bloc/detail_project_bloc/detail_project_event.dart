part of 'detail_project_bloc.dart';

@immutable
sealed class DetailProjectEvent {}

class LoadDetailProjectEvent extends DetailProjectEvent {
  final int projectID;

  LoadDetailProjectEvent({required this.projectID});
}

class DeleteUserEvent extends DetailProjectEvent {
  final int projectID;
  final int profileID;

  DeleteUserEvent(
      {required this.projectID,
      required this.profileID});
}

class AddUserEvent extends DetailProjectEvent {
  final String email;
  final String role;
  final String rate;
  final int projectID;

  AddUserEvent(
      {required this.email,
      required this.role,
      required this.rate,
      required this.projectID});
}

class RevokeInviteEvent extends DetailProjectEvent {
  final int projectID;
  final int invitationsID;

  RevokeInviteEvent(
      {required this.projectID,
      required this.invitationsID});
}
