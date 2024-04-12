import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';

List<UserModel> getAllUsersWhithoutOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  List<UserModel> list = List.from(allUsers);
  for (var usr in allUsers) {
    for (var user in engagements) {
      if (usr.userID == user.profileId) {
        list.remove(usr);
        break;
      }
    }
  }
  return list;
}

List<UserInfoModel> getListUsersOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  final List<UserInfoModel> usersOnProject = [];
  for (var userEngagement in engagements) {
    for (var user in allUsers) {
      if (user.userID == userEngagement.userID) {
        usersOnProject.add(UserInfoModel(
            email: user.email,
            name: user.name,
            profileID: userEngagement.profileId,
            workedTotal: userEngagement.workedTotal));
      }
    }
  }
  return usersOnProject;
}
