import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/users/utils/methods.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';

class UserInfoScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  final List<ProfileIdModel> allProfileID;
  final int index;
  const UserInfoScreen(
      {super.key,
      required this.allProfileID,
      required this.projects,
      required this.index});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          widget.allProfileID[widget.index].name,
        )),
        body: BlocBuilder<DetailProjectBloc, DetailProjectState>(
          bloc: BlocProvider.of<DetailProjectBloc>(context),
          builder: (context, state) {
            final userProjectList = getUserProject(
                widget.projects, widget.allProfileID, widget.index);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: userProjectList.length,
                  itemBuilder: (BuildContext context, int index2) {
                    return GestureDetector(
                      onTap: () {
                        userProjectList[index2].archivedAt == null &&
                                userProjectList[index2].currentUser == "admin" || userProjectList[index2].currentUser == "supervisor"
                            ? showDialog<void>(
                                context: context,
                                builder: (ctx) => MyAlertDialog(
                                      ctx: context,
                                      title: AppLocalizations.of(context)!
                                          .deleteThisUser,
                                      content: AppLocalizations.of(context)!
                                          .wantDeleteUser,
                                      isYes: TextButton(
                                          onPressed: () async {
                                            Navigator.of(ctx).pop();
                                            GetIt.I<DetailProjectBloc>().add(
                                                DeleteUserEvent(
                                                    projectID:
                                                        userProjectList[index2]
                                                            .id,
                                                    profileID: widget
                                                        .allProfileID[
                                                            widget.index]
                                                        .profileID));
                                            showSnackBar(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .deletedUser);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .deleteUser,
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
                                    userProjectList[index2].currentUser ==
                                        "admin"
                                ? const Icon(Icons.delete)
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
