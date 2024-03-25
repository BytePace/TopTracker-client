
import 'package:flutter/material.dart';

import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';


abstract class ProjectProvider extends ChangeNotifier{

  Future<List<ProjectModel>> getProjects();

  Future<DetailProjectModel?> getDetailProject(int id);

  Future<void> restoreProject(BuildContext context, int projectID);

  Future<void> deleteProject(BuildContext context, int projectID);

  List<UserModel> getListUsersOnProject(
      DetailProjectModel detailProjectModel, List<UserModel> allUsers);

  List<ProfileID> getListUsersProfileIDOnProject(
      DetailProjectModel detailProjectModel, List<ProfileID> allUsers);

  List<UserModel> getAllUsersWhithoutOnProject(
      DetailProjectModel detailProjectModel, List<UserModel> allUsers);
}
