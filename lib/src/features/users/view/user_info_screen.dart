import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/alert_dialog.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/users/services/users_services.dart';

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
    return Scaffold(
      appBar: AppBar(
          title: Text(
        allProfileID[index].name,
      )),
      body: Consumer<UserServices>(
        builder: (BuildContext context, UserServices value, Widget? child) {
          final userProjectList =
              value.getUserProject(projects, allProfileID, index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: userProjectList.length,
              itemBuilder: (BuildContext context, int index2) {
                return GestureDetector(
                  onTap: () {
                    userProjectList[index2].archivedAt == null &&
                            userProjectList[index2].currentUser == "admin"
                        ? showDialog<void>(
                            context: context,
                            builder: (ctx) => MyAlertDialog(
                                  ctx: context,
                                  title: "Delete user",
                                  content:
                                      "Are you sure want to delete this user from project?",
                                  isYes: TextButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        value.delUser(
                                            userProjectList[index2].id,
                                            allProfileID[index].profileID,
                                            context);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ))
                        : () {};
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userProjectList[index2].name),
                        userProjectList[index2].archivedAt == null &&
                                userProjectList[index2].currentUser == "admin"
                            ? const Icon(Icons.delete)
                            : Container()
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
