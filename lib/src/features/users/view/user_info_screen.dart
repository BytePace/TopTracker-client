import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/users/utils/methods.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/resources/text.dart';

class UserInfoScreen extends StatelessWidget {
  final List<ProjectModel> projects;
  final List<ProfileIdModel> allProfileID;
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
        body: BlocBuilder<DetailProjectBloc, DetailProjectState>(
          bloc: GetIt.I<DetailProjectBloc>(),
          builder: (context, state) {
            final userProjectList =
                getUserProject(projects, allProfileID, index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: userProjectList.length,
                itemBuilder: (BuildContext context, int index2) {
                  return GestureDetector(
                    onTap: () {
                      userProjectList[index2].archivedAt == null &&
                                  userProjectList[index2].currentUser ==
                                      "admin" ||
                              userProjectList[index2].currentUser ==
                                  "supervisor"
                          ? showDialog<void>(
                              context: context,
                              builder: (ctx) => MyAlertDialog(
                                    ctx: context,
                                    title: DisplayText.deleteThisUser,
                                    content: DisplayText.wantDeleteUser,
                                    isYes: TextButton(
                                        onPressed: () async {
                                          Navigator.of(ctx).pop();
                                          GetIt.I<DetailProjectBloc>().add(
                                              DeleteUserEvent(
                                                  projectID:
                                                      userProjectList[index2]
                                                          .id,
                                                  profileID: allProfileID[index]
                                                      .profileID));
                                        },
                                        child: Text(
                                          DisplayText.deleteUser,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
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
        ));
  }
}
