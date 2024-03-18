import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

class UserInfoScreen extends StatelessWidget {
  final ProjectsModel projects;
  final List<ProfileID> allProfileID;
  final int index;
  const UserInfoScreen(
      {super.key,
      required this.allProfileID,
      required this.projects,
      required this.index});

  List<ProjectModel> getUserProject(
      ProjectsModel projects, List<ProfileID> allUsersList) {
    List<ProjectModel> projectModelList = [];

    for (ProjectModel element in projects.projects) {
      for (var a in element.profilesIDs) {
        if (a == allUsersList[index].profileID) {
          projectModelList.add(element);
        }
      }
    }
    return projectModelList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<UserServices>(
        builder: (BuildContext context, UserServices value, Widget? child) {
          return Column(
            children: List.generate(
                getUserProject(projects, allProfileID).length,
                (index2) => GestureDetector(
                      onTap: () {
                        value.delUser(
                            getUserProject(projects, allProfileID)[index2].id,
                            allProfileID[index].profileID);
                      },
                      child: Text(
                          getUserProject(projects, allProfileID)[index2].name),
                    )),
          );
        },
      ),
    );
  }
}
