import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';

List<UserModel> getListUsersOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  final List<UserModel> usersOnProject = [];
  for (var userEngagement in engagements) {
    for (var user in allUsers) {
      if (userEngagement.profileId == user.profileID) {
        usersOnProject.add(user);
      }
    }
  }
  return usersOnProject;
}

List<ProfileIdModel> getListUsersProfileIDOnProject(
    List<int> engagements, List<ProfileIdModel> allUsersProfileID) {
  final List<ProfileIdModel> usersOnProject = [];
  for (var profileID in engagements) {
    for (var user in allUsersProfileID) {
      if (profileID == user.profileID) {
        usersOnProject.add(user);
      }
    }
  }
  return usersOnProject;
}

List<UserModel> getAllUsersWhithoutOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  List<UserModel> list = List.from(allUsers);
  for (var usr in allUsers) {
    for (var user in engagements) {
      if (usr.profileID == user.profileId) {
        list.remove(usr);
        break;
      }
    }
  }
  return list;
}
