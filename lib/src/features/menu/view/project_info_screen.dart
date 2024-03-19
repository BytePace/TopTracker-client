import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/add_user_form.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/all_users_list.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/invited_on_project.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/user_on_project.dart';

class ProjectInfoScreen extends StatelessWidget {
  final int id;
  final String name;
  final List<UserModel> allUsers;
  const ProjectInfoScreen(
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
                      UserOnProject(
                          detailProjectModel: snapshot.data!,
                          allUsers: projectService.getListUsersOnProject(snapshot.data!, allUsers)),

                      const SizedBox(height: 16),

                      InvitedOnProject(
                        detailProjectModel: snapshot.data!,
                      ),

                      const SizedBox(height: 16),

                      AddUserForm(id: id),

                      const SizedBox(height: 16),
                      
                      AllUsersList(allUsers: allUsers, id: id),
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
