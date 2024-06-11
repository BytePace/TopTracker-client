import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';

List<ProjectModel> getUserProject(
    List<ProjectModel> projects, List<ProfileIdModel> allUsersList, int index) {
  List<ProjectModel> projectModelList = [];

  for (ProjectModel project in projects) {
    for (var userProfileID in project.profilesIDs) {
      if (userProfileID == allUsersList[index].profileID) {
        projectModelList.add(project);
      }
    }
  }
  return projectModelList;
}
