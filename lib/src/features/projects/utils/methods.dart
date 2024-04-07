import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/user_model.dart';

List<UserInfoModel> getListUsersOnProject(
    List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
  print("_-----_");
  print(engagements);
  print(allUsers);
  print("_-----_");
  final List<UserInfoModel> usersOnProject = [];
  for (var userEngagement in engagements) {
    for (var user in allUsers) {
      if (userEngagement.profileId == user.profileID) {
        usersOnProject.add(UserInfoModel(
            email: user.email,
            name: user.name,
            profileID: user.profileID,
            workedTotal: userEngagement.workedTotal));
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
