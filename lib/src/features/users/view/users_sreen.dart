import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';

import 'package:tt_bytepace/src/features/users/view/user_info_screen.dart';

class UsersScreen extends StatelessWidget {
  final List<ProjectModel> projects;
  final List<ProfileIdModel> allProfileID;
  const UsersScreen(
      {super.key, required this.projects, required this.allProfileID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: List.generate(
            allProfileID.length,
            (index) => OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserInfoScreen(
                          allProfileID: allProfileID,
                          projects: projects,
                          index: index)),
                );
              },
              child: Text(allProfileID[index].name,
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
            ),
          ),
        ),
      ),
    );
  }
}
