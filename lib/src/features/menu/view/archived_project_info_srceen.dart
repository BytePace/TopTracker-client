import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/bloc/ProjectListBloc/project_list_bloc.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/alert_dialog.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/tile_user_archived.dart';

class ArchivedProjectInfoScreen extends StatelessWidget {
  final int id;
  final String name;
  final ProjectModel project;
  final List<ProfileID> allUsers;
  const ArchivedProjectInfoScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.allUsers,
      required this.project});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NetworkProjectDataSource>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
          future: viewModel.getDetailProject(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  children: [
                    Card(
                      child: Column(
                        children: List.generate(
                            viewModel
                                .getListUsersProfileIDOnProject(
                                    snapshot.data!.engagements, allUsers)
                                .length,
                            (index) => UserTileArchived(
                                  detailProjectModel: snapshot.data!,
                                  index: index,
                                  allUsers:
                                      viewModel.getListUsersProfileIDOnProject(
                                          snapshot.data!.engagements, allUsers),
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
                                                    await viewModel
                                                        .restoreProject(
                                                            context, id);
                                                    GetIt.I<ProjectListBloc>()
                                                        .add(
                                                            RestoreProjectEvent(
                                                                id: id));
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
                                                    await viewModel
                                                        .deleteProject(
                                                            context, id);
                                                    GetIt.I<ProjectListBloc>()
                                                        .add(DeleteProjectEvent(
                                                            id: id));
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
          }),
    );
  }
}
