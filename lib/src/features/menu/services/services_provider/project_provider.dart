import 'package:flutter/material.dart';

import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

abstract class ProjectProvider extends ChangeNotifier {
  Future<List<ProjectModel>> getProjects();

  Future<DetailProjectModel?> getDetailProject(int id);

  Future<void> restoreProject(BuildContext context, int projectID);

  Future<void> deleteProject(BuildContext context, int projectID);

  List<UserModel> getListUsersOnProject(
      List<UserEngagementsModel> engagements, List<UserModel> allUsers);

  List<ProfileID> getListUsersProfileIDOnProject(
      List<UserEngagementsModel> engagements, List<ProfileID> allUsersProfileID);

  List<UserModel> getAllUsersWhithoutOnProject(
      List<UserEngagementsModel> engagements, List<UserModel> allUsers);
}
