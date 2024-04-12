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
  final BuildContext context;

  DeleteUserEvent(
      {required this.projectID,
      required this.profileID,
      required this.context});
}

class AddUserEvent extends DetailProjectEvent {
  final String email;
  final String role;
  final String rate;
  final int projectID;
  final BuildContext context;

  AddUserEvent(
      {required this.email,
      required this.role,
      required this.rate,
      required this.projectID,
      required this.context});
}

class RevokeInviteEvent extends DetailProjectEvent {
  final int projectID;
  final int invitationsID;
  final BuildContext context;

  RevokeInviteEvent(
      {required this.projectID,
      required this.invitationsID,
      required this.context});
}
