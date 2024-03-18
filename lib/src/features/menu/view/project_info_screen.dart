import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/widget/add_user_form.dart';
import 'package:tt_bytepace/src/features/menu/widget/invited_on_project.dart';
import 'package:tt_bytepace/src/features/menu/widget/user_on_project.dart';

class ProjectInfoScreen extends StatelessWidget {
  final int id;
  final String name;
  final List<UserModel> userOnProject;
  final List<AllUsers> allUsers;
  const ProjectInfoScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.userOnProject,
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
                      const Text("Пользватели на проекте",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      UserOnProject(
                          detailProjectModel: snapshot.data!, state: state),
                      const SizedBox(height: 16),
                      snapshot.data!.invitations.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Приглашенные пользователи",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                InvitedOnProject(
                                  detailProjectModel: snapshot.data!,
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(height: 16),
                      const Text("Добавить пользователя",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      AddUserForm(id: id),
                      const SizedBox(height: 16),
                      
                      Column(
                        children: List.generate(
                          allUsers.length,
                          (index) => GestureDetector(
                            onTap: () {
                              state.addUser(
                                  allUsers[index].email, "", "worker", id);
                            },
                            child: Row(
                              children: [
                                Text(allUsers[index].name),
                              ],
                            ),
                          ),
                        ),
                      ),
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
