import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

class UserInfoScreen extends StatelessWidget {
  final List<ProjectModel> projects;
  final List<ProfileID> allProfileID;
  final int index;
  const UserInfoScreen(
      {super.key,
      required this.allProfileID,
      required this.projects,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final UserServices userServices = UserServices();
    final userProjectList =
        userServices.getUserProject(projects, allProfileID, index);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        allProfileID[index].name,
      )),
      body: Consumer<UserServices>(
        builder: (BuildContext context, UserServices value, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: userProjectList.length,
              itemBuilder: (BuildContext context, int index2) {
                return GestureDetector(
                  onTap: () {
                    value.delUser(userProjectList[index2].id,
                        allProfileID[index].profileID, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userProjectList[index2].name),
                        const Icon(Icons.delete)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
