import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/view/user_info_screen.dart';

class UsersScreen extends StatelessWidget {
  final ProjectsModel projects;
  final AllUsersList allUsersList;
  const UsersScreen(
      {super.key, required this.projects, required this.allUsersList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
          allUsersList.all.length,
          (index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoScreen(
                            allUsersList: allUsersList,
                            projects: projects,
                            index: index)),
                  );
                },
                child: Text(allUsersList.all[index].name),
              )),
    );

  }
}
