
import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
abstract class UserProvider extends ChangeNotifier {
  Future<void> revokeInvite(int invitationID, BuildContext context);

  Future<void> addUser(
      String email, String rate, String role, int id, BuildContext context);

  Future<void> delUser(int projectId, int profileId, BuildContext context);

  Future<List<int>> getProjectsID();

  Future<List<UserModel>> getAllUsers();

  Future<List<ProfileID>> getAllProfileID();

  List<ProjectModel> getUserProject(
      List<ProjectModel> projects, List<ProfileID> allUsersList, int index);

  Future<List<UserModel>> checkAllUsers(List<ProfileID> allProfileID);
}
