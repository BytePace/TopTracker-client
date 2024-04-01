import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';

import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/utils/methods.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/utils/alert_dialog.dart';
import 'package:tt_bytepace/src/features/archived_projects/view/widget/tile_user_archived.dart';

class ArchivedProjectInfoScreen extends StatelessWidget {
  final int id;
  final String name;
  final ProjectModel project;
  final List<ProfileIdModel> allUsers;
  const ArchivedProjectInfoScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.allUsers,
      required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: BlocBuilder<ProjectBloc, ProjectState>(
            bloc: BlocProvider.of<ProjectBloc>(context),
            builder: (context, state) {
              if (state is ProjectListLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView(
                    children: [
                      Card(
                        child: Column(
                          children: List.generate(
                              project.profilesIDs.length,
                              (index) => UserTileArchived(
                                    index: index,
                                    allUsers: getListUsersProfileIDOnProject(
                                        project.profilesIDs, allUsers),
                                  )),
                        ),
                      ),
                      const SizedBox(height: 16),
                      project.currentUser == "admin"
                          ? Column(
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      showDialog<void>(
                                          context: context,
                                          builder: (ctx) => MyAlertDialog(
                                                ctx: context,
                                                title: "Restore project",
                                                content:
                                                    "Are you sure want to restore this project?",
                                                isYes: TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(ctx).pop();
                                                      GetIt.I<ProjectBloc>().add(
                                                          RestoreProjectEvent(
                                                              id: id,
                                                              context:
                                                                  context));
                                                    },
                                                    child: const Text(
                                                      "Restore",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              ));
                                    },
                                    child: const Text("Restore Project")),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                    onPressed: () {
                                      showDialog<void>(
                                          context: context,
                                          builder: (ctx) => MyAlertDialog(
                                                ctx: context,
                                                title: "Delete project",
                                                content:
                                                    "Are you sure want to delete this project?",
                                                isYes: TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(ctx).pop();
                                                      GetIt.I<ProjectBloc>().add(
                                                          DeleteProjectEvent(
                                                              id: id,
                                                              context:
                                                                  context));
                                                    },
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              ));
                                    },
                                    child: const Text("Delete Project"))
                              ],
                            )
                          : Container()
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
