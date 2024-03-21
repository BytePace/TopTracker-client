import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/add_user_form.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/all_users_list.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/invited_on_project.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/tile_user_archived.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/user_on_project.dart';

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
    final ProjectService projectService = ProjectService();
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Consumer<UserServices>(
          builder: (BuildContext context, UserServices state, Widget? child) {
        return FutureBuilder(
            future: projectService.getDetailProject(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView(
                    children: [
                      Card(
                        child: Column(
                          children: List.generate(
                              projectService
                                  .getListUsersProfileIDOnProject(
                                      snapshot.data!, allUsers)
                                  .length,
                              (index) => UserTileArchived(
                                    detailProjectModel: snapshot.data!,
                                    index: index,
                                    allUsers: projectService
                                        .getListUsersProfileIDOnProject(
                                            snapshot.data!, allUsers),
                                  )),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                          onPressed: () async {
                            projectService.restoreProject(context, id);
                          },
                          child: const Text("Restore Project"))
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      }),
    );
  }
}
