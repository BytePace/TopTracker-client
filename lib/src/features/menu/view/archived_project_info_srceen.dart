import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/tile_user_archived.dart';

class ArchivedProjectInfoScreen extends StatelessWidget {
  final int id;
  final String name;
  final List<ProfileID> allUsers;
  const ArchivedProjectInfoScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.allUsers});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProjectService>(context);

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
                                    snapshot.data!, allUsers)
                                .length,
                            (index) => UserTileArchived(
                                  detailProjectModel: snapshot.data!,
                                  index: index,
                                  allUsers: viewModel
                                      .getListUsersProfileIDOnProject(
                                          snapshot.data!, allUsers),
                                )),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                        onPressed: () async {
                          viewModel.restoreProject(context, id);
                        },
                        child: const Text("Restore Project")),
                    const SizedBox(height: 16),
                    OutlinedButton(
                        onPressed: () async {
                         viewModel.deleteProject(context, id);
                        },
                        child: const Text("Delete Project"))
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
